import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/order/order.dart' as order_model;
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuItemRepository menuItemRepository;
  final OrderRepository orderRepository;
  final QueueEntryRepository queueEntryRepository;
  final MenuCategoryRepository menuCategoryRepository;
  final UserProvider userProvider;
  final AddOnRepository addOnRepository;
  final MenuSizeRepository menuSizeRepository;
  final RestaurantRepository restaurantRepository;

  MenuViewModel({
    required this.menuItemRepository,
    required this.orderRepository,
    required this.queueEntryRepository,
    required this.menuCategoryRepository,
    required this.userProvider,
    required this.addOnRepository,
    required this.menuSizeRepository,
    required this.restaurantRepository,
  });

  // ================= USER =================
  String get userName => userProvider.asCustomer?.name ?? "Guest";

  // ================= MENU ITEMS =================
  List<MenuItem> _menuItems = [];
  List<MenuItem> get menuItems => _menuItems;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  String get restaurantName => _restaurant?.name ?? "";

  DocumentSnapshot<Map<String, dynamic>>? _lastMenuItemDoc;
  bool _hasMoreMenuItems = true;
  bool get hasMoreMenuItems => _hasMoreMenuItems;

  bool _isMenuLoading = false;
  bool get isMenuLoading => _isMenuLoading;

  // ================= MENU CATEGORIES =================
  List<MenuItemCategory> _menuCategories = [];
  List<MenuItemCategory> get menuCategories => _menuCategories;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ================= QUEUE ENTRY =================
  QueueEntry? _currentQueueEntry;
  QueueEntry? get currentQueueEntry => _currentQueueEntry;

  bool get isInQueue => _currentQueueEntry != null;
  String? get queueNumber => _currentQueueEntry?.queueNumber?.toString();

  // ================= ORDER =================
  order_model.Order get currentOrder => orderRepository.currentOrder;
  List<OrderItem> get cartItems => currentOrder.inCart;
  List<OrderItem> get orderedItems => currentOrder.ordered;

  int get totalCartItemsCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalCartAmount => cartItems.fold(0.0, (sum, item) {
    final addOnsTotal = item.addOns.values.fold(0.0, (a, b) => a + b);
    return sum + (item.menuItemPrice + addOnsTotal) * item.quantity;
  });

  // ================= INITIALIZE =================
  Future<void> initialize() async {
    await _loadQueueEntry();
    await _loadRestaurant();
    await Future.wait([loadMenuCategories(), loadMenuItems()]);
  }

  // ================= QUEUE ENTRY =================
  Future<void> _loadQueueEntry() async {
    final customer = userProvider.asCustomer;
    if (customer?.currentHistoryId == null) return;

    try {
      _currentQueueEntry = await queueEntryRepository.getQueueEntryById(
        customer!.currentHistoryId!,
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading queue entry: $e");
    }
  }

  Future<void> _loadRestaurant() async {
    final restId = await _getRestaurantIdFromQueue();
    if (restId == null) return;

    try {
      _restaurant = await restaurantRepository.getById(restId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading restaurant: $e");
    }
  }

  // ================= RESTAURANT =================
  Future<String?> _getRestaurantIdFromQueue() async {
    if (_currentQueueEntry != null) return _currentQueueEntry!.restId;

    final customer = userProvider.asCustomer;
    if (customer?.currentHistoryId == null) return null;

    try {
      final entry = await queueEntryRepository.getQueueEntryById(
        customer!.currentHistoryId!,
      );
      _currentQueueEntry = entry;
      return entry?.restId;
    } catch (e) {
      debugPrint("Error fetching restaurant id from queue: $e");
      return null;
    }
  }

  // ================= HELPER METHOD =================
  // This method enriches menu items with sizes and add-ons
  Future<List<MenuItem>> _enrichMenuItems(List<MenuItem> items) async {
    if (items.isEmpty) return [];

    return await Future.wait(
      items.map((item) async {
        try {
          // Fetch add-ons
          final (addOns, _) = await addOnRepository.getAddOnsByMenuItemId(
            item.id,
            50,
            null,
          );

          // Fetch sizes
          final sizes = await Future.wait(
            item.menuSizeOptionIds.map((id) async {
              try {
                final size = await menuSizeRepository.getMenuSizeById(id);
                if (size == null) {
                  debugPrint(
                    "Size not found for ID: $id in item: ${item.name}",
                  );
                }
                return size;
              } catch (e) {
                debugPrint("Error fetching size $id: $e");
                return null;
              }
            }),
          );

          final validSizes = sizes.whereType<MenuSize>().toList();

          // Log for debugging
          if (validSizes.isEmpty && item.menuSizeOptionIds.isNotEmpty) {
            debugPrint(
              "⚠️ No valid sizes found for ${item.name}. Size IDs: ${item.menuSizeOptionIds}",
            );
          }

          // Calculate min price from sizes or use existing minPrice
          final minPrice = validSizes.isNotEmpty
              ? validSizes.map((s) => s.price).reduce((a, b) => a < b ? a : b)
              : item.minPrice;

          return item.copyWith(
            addOns: addOns,
            sizes: validSizes,
            minPrice: minPrice,
          );
        } catch (e) {
          debugPrint("Error enriching item ${item.name}: $e");
          return item;
        }
      }),
    );
  }

  // ================= MENU LOADING =================
  Future<void> loadMenuItems({int limit = 20}) async {
    if (_isMenuLoading) return;

    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getRestaurantIdFromQueue();
    if (restId == null) {
      _menuItems = [];
      _isMenuLoading = false;
      notifyListeners();
      return;
    }

    try {
      final (items, lastDoc) = await menuItemRepository.getAll(
        restId,
        limit,
        null,
      );

      // Enrich items with sizes and add-ons
      final enrichedItems = await _enrichMenuItems(items);

      _menuItems = enrichedItems;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;

      debugPrint("✅ Loaded ${_menuItems.length} menu items with sizes");
    } catch (e) {
      debugPrint("Error loading menu items: $e");
      _menuItems = [];
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreMenuItems({int limit = 20}) async {
    if (_isMenuLoading || !_hasMoreMenuItems) return;

    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getRestaurantIdFromQueue();
    if (restId == null) return;

    try {
      final (items, lastDoc) = await menuItemRepository.getAll(
        restId,
        limit,
        _lastMenuItemDoc,
      );

      // Enrich new items with sizes and add-ons
      final enrichedItems = await _enrichMenuItems(items);
      _menuItems.addAll(enrichedItems);
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;

      debugPrint("✅ Loaded ${enrichedItems.length} more menu items");
    } catch (e) {
      debugPrint("Pagination error: $e");
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  // ================= CATEGORIES =================
  Future<void> loadMenuCategories() async {
    try {
      final (categories, _) = await menuCategoryRepository.getAll(50, null);
      _menuCategories = categories;

      if (_menuCategories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _menuCategories.first.id;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }

  // ================= SEARCH =================
  Future<void> searchMenuItems(String query, {int limit = 20}) async {
    _searchQuery = query;
    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getRestaurantIdFromQueue();
    if (restId == null) return;

    try {
      final (items, lastDoc) = await menuItemRepository.getSearchMenuItems(
        restId,
        query,
        limit,
        null,
      );

      // Enrich search results with sizes and add-ons
      final enrichedItems = await _enrichMenuItems(items);
      _menuItems = enrichedItems;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;

      debugPrint("🔍 Search found ${enrichedItems.length} items for '$query'");
    } catch (e) {
      debugPrint("Search error: $e");
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  // ================= CATEGORY FILTER =================
  Future<void> filterByCategory(String? categoryId, {int limit = 20}) async {
    _selectedCategory = categoryId;
    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getRestaurantIdFromQueue();
    if (restId == null) return;

    try {
      if (categoryId == null || categoryId.isEmpty) {
        await loadMenuItems(limit: limit);
        return;
      }

      final (items, lastDoc) = await menuItemRepository.getMenuItemByCategoryId(
        restId,
        categoryId,
        limit,
        null,
      );

      // Enrich filtered items with sizes and add-ons
      final enrichedItems = await _enrichMenuItems(items);
      _menuItems = enrichedItems;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;

      debugPrint("🏷️ Filtered by category: ${enrichedItems.length} items");
    } catch (e) {
      debugPrint("Category filter error: $e");
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  // ================= FILTERED LIST =================
  List<MenuItem> get filteredMenuItems {
    return _menuItems.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == null ||
          _selectedCategory!.isEmpty ||
          item.category.id == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ================= REFRESH =================
  Future<void> refresh() async {
    await Future.wait([loadMenuCategories(), loadMenuItems()]);
  }

  // ================= DEBUG METHOD =================
  // Call this to check the first menu item's sizes
  Future<void> debugCheckSizes() async {
    if (_menuItems.isEmpty) {
      debugPrint("No menu items loaded");
      return;
    }

    final firstItem = _menuItems.first;
    debugPrint("=== DEBUG: ${firstItem.name} ===");
    debugPrint("Size option IDs: ${firstItem.menuSizeOptionIds}");
    debugPrint("Sizes loaded: ${firstItem.sizes.length}");

    for (var size in firstItem.sizes) {
      debugPrint("  - ${size.name}: \$${size.price}");
    }

    if (firstItem.sizes.isEmpty && firstItem.menuSizeOptionIds.isNotEmpty) {
      debugPrint("⚠️ WARNING: Item has size IDs but no sizes loaded!");
      debugPrint("Try fetching one size manually:");

      for (var sizeId in firstItem.menuSizeOptionIds) {
        try {
          final size = await menuSizeRepository.getMenuSizeById(sizeId);
          debugPrint(
            "  Size $sizeId: ${size != null ? size.name : 'NOT FOUND'}",
          );
        } catch (e) {
          debugPrint("  Error fetching size $sizeId: $e");
        }
      }
    }
  }
}
