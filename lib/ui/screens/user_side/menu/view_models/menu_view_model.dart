import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/customer_menu_service.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';

class MenuViewModel extends ChangeNotifier {
  final UserProvider userProvider;
  final CustomerMenuService menuService;
  final OrderProvider orderProvider;
  final QueueEntryRepository queueEntryRepository;
  final RestaurantRepository restaurantRepository;

  MenuViewModel({
    required this.menuService,
    required this.orderProvider,
    required this.queueEntryRepository,
    required this.userProvider,
    required this.restaurantRepository,
  });

  // ================= STATE =================
  List<MenuItem> _menuItems = [];
  List<MenuItemCategory> _menuCategories = [];
  Restaurant? _restaurant;
  QueueEntry? _currentQueueEntry;
  DocumentSnapshot<Map<String, dynamic>>? _lastMenuItemDoc;

  String? _selectedCategory;
  String _searchQuery = '';
  bool _hasMoreMenuItems = true;
  bool _isMenuLoading = false;

  // ================= GETTERS =================
  List<MenuItem> get menuItems => _menuItems;
  List<MenuItemCategory> get menuCategories => _menuCategories;
  Restaurant? get restaurant => _restaurant;
  String get restaurantName => _restaurant?.name ?? "";
  String get userName => userProvider.asCustomer?.name ?? "Guest";
  bool get isMenuLoading => _isMenuLoading;
  bool get hasMoreMenuItems => _hasMoreMenuItems;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  QueueEntry? get currentQueueEntry => _currentQueueEntry;
  bool get isInQueue => _currentQueueEntry != null;
  String? get queueNumber => _currentQueueEntry?.queueNumber?.toString();

  Order get currentOrder => orderProvider.currentOrder!;
  int get totalCartItemsCount => orderProvider.totalItemsCount;
  double get totalCartAmount => orderProvider.totalAmount;

  // ================= INITIALIZE =================
  Future<void> initialize() async {
    await _loadQueueAndRestaurant();
    if (_restaurant != null) {
      await Future.wait([loadMenuCategories(), loadMenuItems()]);
    }
  }

  Future<void> _loadQueueAndRestaurant() async {
    final customer = userProvider.asCustomer;
    if (customer?.currentHistoryId == null) return;

    _currentQueueEntry = await queueEntryRepository.getQueueEntryById(
      customer!.currentHistoryId!,
    );
    if (_currentQueueEntry != null) {
      _restaurant = await restaurantRepository.getById(
        _currentQueueEntry!.restId,
      );
    }
    notifyListeners();
  }

  // ================= MENU LOADING =================
  Future<void> loadMenuItems({int limit = 20, bool isLoadMore = false}) async {
    if (_isMenuLoading || (isLoadMore && !_hasMoreMenuItems)) return;
    final restId = _restaurant?.id;
    if (restId == null) return;

    _isMenuLoading = true;
    notifyListeners();

    try {
      final (items, nextDoc) = await menuService.getMenuItems(
        restId,
        categoryId: _selectedCategory,
        searchQuery: _searchQuery,
        limit: limit,
        lastDoc: isLoadMore ? _lastMenuItemDoc : null,
      );

      if (isLoadMore) {
        _menuItems.addAll(items.cast<MenuItem>());
      } else {
        _menuItems = items.cast<MenuItem>();
      }

      _lastMenuItemDoc = nextDoc;
      _hasMoreMenuItems = nextDoc != null;
    } catch (e) {
      debugPrint("MenuViewModel Error: $e");
    } finally {
      _isMenuLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMenuItems() => loadMenuItems(isLoadMore: true);

  Future<void> loadMenuCategories() async {
    if (_restaurant == null) return;
    _menuCategories = await menuService.getCategories(_restaurant!.id);
    if (_menuCategories.isNotEmpty && _selectedCategory == null) {
      _selectedCategory = _menuCategories.first.id;
    }
    notifyListeners();
  }

  // ================= SEARCH & FILTER =================
  Future<void> searchMenuItems(String query) async {
    _searchQuery = query;
    _selectedCategory = null; // Clear category when searching
    await loadMenuItems();
  }

  Future<void> filterByCategory(String? categoryId) async {
    _selectedCategory = categoryId;
    _searchQuery = ''; // Clear search when filtering
    await loadMenuItems();
  }

  // ================= REFRESH =================
  Future<void> refresh() => initialize();
}
