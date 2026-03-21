import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/order/order.dart' as order_model;
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuItemRepository menuItemRepository;
  final OrderRepository orderRepository;
  final QueueEntryRepository queueEntryRepository;
  final MenuCategoryRepository menuCategoryRepository;
  final UserProvider userProvider;

  MenuViewModel({
    required this.menuItemRepository,
    required this.orderRepository,
    required this.queueEntryRepository,
    required this.menuCategoryRepository,
    required this.userProvider,
  });

  // ================= USER =================

  String get userName => userProvider.asCustomer?.name ?? "Guest";

  // ================= MENU ITEMS =================

  List<MenuItem> _menuItems = [];
  List<MenuItem> get menuItems => _menuItems;

  DocumentSnapshot<Map<String, dynamic>>? _lastMenuItemDoc;

  bool _hasMoreMenuItems = true;
  bool get hasMoreMenuItems => _hasMoreMenuItems;

  bool _isMenuLoading = false;
  bool get isMenuLoading => _isMenuLoading;

  // ================= MENU CATEGORIES =================

  List<MenuItemCategory> _menuCategories = [];
  List<MenuItemCategory> get menuCategories => _menuCategories;

  // ================= QUEUE =================

  QueueEntry? _currentQueueEntry;
  QueueEntry? get currentQueueEntry => _currentQueueEntry;

  bool _isCheckingQueue = true;
  bool get isCheckingQueue => _isCheckingQueue;

  String? _queueErrorMessage;
  String? get queueErrorMessage => _queueErrorMessage;

  // Queue status constants
  static const String QUEUE_STATUS_WAITING = 'waiting';
  static const String QUEUE_STATUS_SERVING = 'serving';
  static const String QUEUE_STATUS_COMPLETED = 'completed';
  static const String QUEUE_STATUS_CANCELLED = 'cancelled';

  final List<String> _allowedOrderStatuses = [QUEUE_STATUS_SERVING];

  // ================= FILTERS =================

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

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
    await checkQueueStatus();

    if (canOrder) {
      await Future.wait([loadMenuCategories(), loadMenuItems()]);
    }
  }

  // ================= QUEUE VALIDATION =================

  String _normalizeStatus(String status) => status.trim().toLowerCase();

  bool get canOrder {
    if (_currentQueueEntry == null) return false;
    return _allowedOrderStatuses.contains(
      _normalizeStatus(_currentQueueEntry!.status.name),
    );
  }

  bool get isInQueue => _currentQueueEntry != null;

  // Check if user has joined queue but not checked in
  bool get isWaitingNotCheckedIn {
    if (_currentQueueEntry == null) return false;
    return _normalizeStatus(_currentQueueEntry!.status.name) ==
        QUEUE_STATUS_WAITING;
  }

  // Get queue number for display
  String? get queueNumber {
    return _currentQueueEntry?.queueNumber?.toString();
  }

  Future<void> checkQueueStatus() async {
    _isCheckingQueue = true;
    _queueErrorMessage = null;
    notifyListeners();

    final customer = userProvider.asCustomer;

    if (customer == null) {
      _setQueueError('No user logged in');
      return;
    }

    // Case 1: customer.currentHistoryId is null (not yet joined queue)
    if (customer.currentHistoryId == null) {
      _setQueueError('NO_QUEUE');
      return;
    }

    try {
      _currentQueueEntry = await queueEntryRepository.getQueueEntryById(
        customer.currentHistoryId!,
      );

      if (_currentQueueEntry == null) {
        _setQueueError('Queue entry not found');
        return;
      }

      final status = _normalizeStatus(_currentQueueEntry!.status.name);

      // Case 2: joined (waiting) but not yet checked in
      if (status == QUEUE_STATUS_WAITING) {
        _queueErrorMessage = 'WAITING_NOT_CHECKED_IN';
      }
      // Case 3: not allowed to order (other statuses)
      else if (!_allowedOrderStatuses.contains(status)) {
        _queueErrorMessage = _getQueueRestrictionMessage(status);
      }
    } catch (e) {
      debugPrint("Queue status error: $e");
      _setQueueError('Error checking queue status');
    }

    _isCheckingQueue = false;
    notifyListeners();
  }

  void _setQueueError(String message) {
    _queueErrorMessage = message;
    _isCheckingQueue = false;
    notifyListeners();
  }

  String _getQueueRestrictionMessage(String status) {
    switch (status) {
      case QUEUE_STATUS_COMPLETED:
      case QUEUE_STATUS_CANCELLED:
        return 'This queue is no longer active.';
      default:
        return 'Ordering is not available at this time.';
    }
  }

  // Get user-friendly error message for display
  String? getDisplayErrorMessage() {
    if (_queueErrorMessage == null) return null;

    switch (_queueErrorMessage) {
      case 'NO_QUEUE':
        return 'We could not find your joined queue. Please join and check in.';
      case 'WAITING_NOT_CHECKED_IN':
        final queueNum = queueNumber ?? 'unknown';
        return 'You have not checked in yet. Please make sure to check in when it is your turn.\n\nYour current queue: $queueNum';
      default:
        return _queueErrorMessage;
    }
  }

  String? get orderRestrictionMessage {
    return getDisplayErrorMessage();
  }

  // ================= RESTAURANT =================

  Future<String?> _getCurrentRestaurantId() async {
    return _currentQueueEntry?.restId;
  }

  // ================= MENU LOADING =================

  Future<void> loadMenuItems({int limit = 20}) async {
    if (_isMenuLoading || !canOrder) return;

    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getCurrentRestaurantId();

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

      _menuItems = items;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;
    } catch (e) {
      debugPrint("Error loading menu items: $e");
      _menuItems = [];
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreMenuItems({int limit = 20}) async {
    if (_isMenuLoading || !_hasMoreMenuItems || !canOrder) return;

    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getCurrentRestaurantId();
    if (restId == null) return;

    try {
      final (items, lastDoc) = await menuItemRepository.getAll(
        restId,
        limit,
        _lastMenuItemDoc,
      );

      _menuItems.addAll(items);
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;
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
    if (!canOrder) return;

    _searchQuery = query;
    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getCurrentRestaurantId();
    if (restId == null) return;

    try {
      final (items, lastDoc) = await menuItemRepository.getSearchMenuItems(
        restId,
        query,
        limit,
        null,
      );

      _menuItems = items;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;
    } catch (e) {
      debugPrint("Search error: $e");
    }

    _isMenuLoading = false;
    notifyListeners();
  }

  // ================= CATEGORY FILTER =================

  Future<void> filterByCategory(String? categoryId, {int limit = 20}) async {
    if (!canOrder) return;

    _selectedCategory = categoryId;
    _isMenuLoading = true;
    notifyListeners();

    final restId = await _getCurrentRestaurantId();
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

      _menuItems = items;
      _lastMenuItemDoc = lastDoc;
      _hasMoreMenuItems = lastDoc != null;
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
    await checkQueueStatus();

    if (canOrder) {
      await Future.wait([loadMenuCategories(), loadMenuItems()]);
    }
  }
}
