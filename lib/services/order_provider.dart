import 'dart:async';
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/user_provider.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService;
  UserProvider userProvider;

  Order? _currentOrder;
  Order? _localOrder;
  StreamSubscription<Order?>? _sub;

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

    _sub = orderService.streamCurrentOrder.listen((order) async {
      if (order != null) {
        // ✅ Load full order with menu items
        final fullOrder = await orderService.getOrderDetailsById(order.id);

        if (fullOrder != null) {
          _currentOrder = fullOrder;
          _localOrder = fullOrder;
          notifyListeners();
        }
      }
    });
  }

  // ---------------------------
  // Getters
  // ---------------------------

  Order? get currentOrder => _localOrder ?? _currentOrder;

  Future<Order?> get currentOrderInDetails async {
    final id = _localOrder?.id ?? _currentOrder?.id;
    if (id == null || id.isEmpty) return null;

    final detailedOrder = await orderService.getOrderDetailsById(id);

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
  // Cart Actions - Immediate Save
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

    await _saveOrder(cart);
  }

  Future<void> updateCart(OrderItem updatedItem) async {
    if (currentOrder == null) return;

    final cart = List<OrderItem>.from(currentOrder!.inCart);
    final index = cart.indexWhere((item) => _isSameItem(item, updatedItem));

    if (index != -1) {
      cart[index] = updatedItem;
      await _saveOrder(cart);
    }
  }

  Future<void> removeItem(OrderItem target) async {
    if (currentOrder == null) return;

    final cart = currentOrder!.inCart
        .where((item) => !_isSameItem(item, target))
        .toList();

    await _saveOrder(cart);
  }

  Future<void> clearCart() async {
    if (currentOrder == null) return;
    await _saveOrder([]);
  }

  // ---------------------------
  // Save Logic
  // ---------------------------

  Future<void> _saveOrder(List<OrderItem> cart) async {
    // Update UI immediately
    _localOrder = currentOrder!.copyWith(inCart: cart);
    notifyListeners();

    // Save to Firestore
    try {
      await orderService.saveOrder(_localOrder!);
      _currentOrder = _localOrder;
    } catch (e) {
      debugPrint('Error saving order: $e');
      // Revert on error
      _localOrder = _currentOrder;
      notifyListeners();
    }
  }

  bool _isSameItem(OrderItem a, OrderItem b) {
    return a.menuItemId == b.menuItemId &&
        a.size.name == b.size.name &&
        _mapEquals(a.addOns, b.addOns) &&
        a.note == b.note;
  }

  bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (b[key] != a[key]) return false;
    }
    return true;
  }

  void updateUserProvider(UserProvider newUserProvider) {
    userProvider = newUserProvider;
    _currentOrder = null;
    _localOrder = null;
    _setupStream();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
