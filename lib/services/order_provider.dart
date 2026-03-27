import 'dart:async';
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/user_provider.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService;
  UserProvider userProvider;

  Order? _currentOrder; // Source of truth from Firestore
  Order? _localOrder; // Local working copy (Optimistic)
  StreamSubscription<Order?>? _sub;
  Timer? _saveDebouncer;

  // Track how many updates are "in flight" to prevent ghosting
  int _pendingActions = 0;

  OrderProvider({required this.orderService, required this.userProvider}) {
    _init();
  }

  void _init() {
    _setupStream();
  }

  void _setupStream() {
    _sub?.cancel();
    final queueHistoryId = userProvider.asCustomer?.currentHistoryId;

    if (queueHistoryId != null) {
      orderService.listenToQueue(queueHistoryId);
    }

    _sub = orderService.streamCurrentOrder.listen((order) {
      if (order != null) {
        _currentOrder = order;

        // CRITICAL: Only overwrite local state if no saves are pending.
        // This prevents the "Ghost Update" where the stream returns
        // old data while the server is still processing your newest change.
        if (_pendingActions == 0) {
          _localOrder = order;
          notifyListeners();
        }
      }
    });
  }

  // ---------------------------
  // Getters
  // ---------------------------

  // Always prefer the local copy if it exists
  Order? get currentOrder => _localOrder ?? _currentOrder;

  /// Returns detailed order, but merges in the local optimistic cart
  /// so the user doesn't see "ghost" old data in the details view.
  Future<Order?> get currentOrderInDetails async {
    final id = _localOrder?.id ?? _currentOrder?.id;
    if (id == null || id.isEmpty) return null;

    final detailedOrder = await orderService.getOrderDetailsById(id);

    // Merge local cart into the details if we have pending changes
    if (detailedOrder != null && _localOrder != null) {
      return detailedOrder.copyWith(inCart: _localOrder!.inCart);
    }
    return detailedOrder;
  }

  List<OrderItem> get items => currentOrder?.inCart ?? [];

  int get totalItemsCount =>
      currentOrder?.inCart.fold(0, (sum, i) => sum! + i.quantity) ?? 0;

  double get totalAmount {
    final order = currentOrder;
    if (order == null) return 0;
    return order.inCart.fold(0.0, (sum, item) {
      final addOnsTotal = item.addOns.values.fold(0.0, (a, b) => a + b);
      return sum + (item.menuItemPrice + addOnsTotal) * item.quantity;
    });
  }

  // ---------------------------
  // Cart Actions
  // ---------------------------

  Future<void> addToCart(OrderItem newItem) async {
    if (currentOrder == null) return;

    final cart = List<OrderItem>.from(currentOrder!.inCart);
    final index = cart.indexWhere((item) => _isSameItem(item, newItem));

    if (index != -1) {
      cart[index] = cart[index].copyWith(
        quantity: cart[index].quantity + newItem.quantity,
      );
    } else {
      cart.add(newItem);
    }

    _applyOptimisticUpdate(cart);
  }

  Future<void> updateCart(OrderItem updatedItem) async {
    if (currentOrder == null) return;

    final cart = List<OrderItem>.from(currentOrder!.inCart);
    final index = cart.indexWhere((item) => _isSameItem(item, updatedItem));

    if (index != -1) {
      cart[index] = updatedItem;
      _applyOptimisticUpdate(cart);
    }
  }

  Future<void> removeItem(OrderItem target) async {
    if (currentOrder == null) return;

    final cart = currentOrder!.inCart
        .where((item) => !_isSameItem(item, target))
        .toList();

    _applyOptimisticUpdate(cart);
  }

  Future<void> clearCart() async {
    if (currentOrder == null) return;
    _applyOptimisticUpdate([]);
  }

  // ---------------------------
  // Internal Logic
  // ---------------------------

  void _applyOptimisticUpdate(List<OrderItem> cart) {
    _localOrder = currentOrder!.copyWith(inCart: cart);
    _pendingActions++; // Block incoming stream overwrites
    notifyListeners();
    _debounceSave();
  }

  void _debounceSave() {
    _saveDebouncer?.cancel();
    _saveDebouncer = Timer(const Duration(milliseconds: 500), () async {
      await _saveToFirestore();
    });
  }

  Future<void> _saveToFirestore() async {
    if (_localOrder == null) return;

    try {
      await orderService.saveOrder(_localOrder!);
      _currentOrder = _localOrder;
    } catch (e) {
      debugPrint('Error saving order: $e');
      // On failure, revert to the last known good server state
      _localOrder = _currentOrder;
      notifyListeners();
    } finally {
      // Small delay after save to let the Firestore stream "catch up"
      Future.delayed(const Duration(milliseconds: 300), () {
        _pendingActions = 0;
      });
    }
  }

  bool _isSameItem(OrderItem a, OrderItem b) {
    return a.menuItemId == b.menuItemId &&
        a.size.name == b.size.name &&
        _mapEquals(a.addOns, b.addOns);
  }

  bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (b[key] != a[key]) return false;
    }
    return true;
  }

  void updateUserProvider(UserProvider newUserProvider) {
    _saveDebouncer?.cancel();
    userProvider = newUserProvider;
    _currentOrder = null;
    _localOrder = null;
    _pendingActions = 0;
    _setupStream();
  }

  @override
  void dispose() {
    _saveDebouncer?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
