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
  Order? _localOrder; // Local working copy for optimistic updates
  StreamSubscription<Order?>? _sub;
  Timer? _saveDebouncer; // Debouncer to prevent too many saves
  bool _isSaving = false; // Prevent concurrent saves

  OrderProvider({required this.orderService, required this.userProvider}) {
    _init();
  }

  // ---------------------------
  // Init
  // ---------------------------
  void _init() {
    final queueHistoryId = userProvider.asCustomer?.currentHistoryId;

    if (queueHistoryId != null) {
      orderService.listenToQueue(queueHistoryId);
    }

    _sub = orderService.streamCurrentOrder.listen((order) {
      if (order != null) {
        _currentOrder = order;
        // Only update local order if we're not in the middle of an optimistic update
        if (!_isSaving) {
          _localOrder = order;
        }
        notifyListeners();
      }
    });
  }

  // ---------------------------
  // Getters
  // ---------------------------
  Order? get currentOrder => _localOrder ?? _currentOrder;
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
  // Cart Actions (Optimized with optimistic updates)
  // ---------------------------

  Future<void> addToCart(OrderItem newItem) async {
    if (currentOrder == null) return;

    // Update local copy immediately (optimistic update)
    final cart = List<OrderItem>.from(currentOrder!.inCart);

    final index = cart.indexWhere(
      (item) =>
          item.menuItemId == newItem.menuItemId &&
          item.size.name == newItem.size.name &&
          _mapEquals(item.addOns, newItem.addOns),
    );

    if (index != -1) {
      cart[index] = cart[index].copyWith(
        quantity: cart[index].quantity + newItem.quantity,
      );
    } else {
      cart.add(newItem);
    }

    _updateLocalOrder(cart);
    _debounceSave();
  }

  Future<void> updateCart(OrderItem updatedItem) async {
    if (currentOrder == null) return;

    // Update local copy immediately
    final cart = List<OrderItem>.from(currentOrder!.inCart);

    final index = cart.indexWhere(
      (item) =>
          item.menuItemId == updatedItem.menuItemId &&
          item.size.name == updatedItem.size.name &&
          _mapEquals(item.addOns, updatedItem.addOns),
    );

    if (index != -1) {
      cart[index] = updatedItem;
      _updateLocalOrder(cart);
      _debounceSave();
    }
  }

  Future<void> removeItem(OrderItem target) async {
    if (currentOrder == null) return;

    // Update local copy immediately
    final cart = currentOrder!.inCart.where((item) {
      return !(item.menuItemId == target.menuItemId &&
          item.size.name == target.size.name &&
          _mapEquals(item.addOns, target.addOns));
    }).toList();

    _updateLocalOrder(cart);
    _debounceSave();
  }

  Future<void> clearCart() async {
    if (currentOrder == null) return;
    _updateLocalOrder([]);
    _debounceSave();
  }

  // ---------------------------
  // Helper Methods
  // ---------------------------

  void _updateLocalOrder(List<OrderItem> cart) {
    if (currentOrder == null) return;
    _localOrder = currentOrder!.copyWith(inCart: cart);
    notifyListeners(); // UI updates instantly
  }

  void _debounceSave() {
    _saveDebouncer?.cancel();
    _saveDebouncer = Timer(const Duration(milliseconds: 500), () async {
      await _saveToFirestore();
    });
  }

  Future<void> _saveToFirestore() async {
    if (_localOrder == null || _isSaving) return;

    _isSaving = true;

    try {
      // Only save if local order differs from current order
      if (_localOrder != _currentOrder) {
        await orderService.saveOrder(_localOrder!);
        // Update current order reference after successful save
        _currentOrder = _localOrder;
      }
    } catch (e) {
      debugPrint('Error saving order: $e');
      // Optionally revert local order if save fails
      if (_currentOrder != null) {
        _localOrder = _currentOrder;
        notifyListeners();
      }
    } finally {
      _isSaving = false;
    }
  }

  bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

  // ---------------------------
  // Update dependency
  // ---------------------------
  void updateUserProvider(UserProvider newUserProvider) {
    _saveDebouncer?.cancel();
    _sub?.cancel();

    userProvider = newUserProvider;
    _currentOrder = null;
    _localOrder = null;

    final queueHistoryId = userProvider.asCustomer?.currentHistoryId;

    if (queueHistoryId != null) {
      orderService.listenToQueue(queueHistoryId);
    }

    _sub = orderService.streamCurrentOrder.listen((order) {
      if (order != null) {
        _currentOrder = order;
        if (!_isSaving) {
          _localOrder = order;
        }
        notifyListeners();
      }
    });
  }

  // ---------------------------
  // Dispose
  // ---------------------------
  @override
  void dispose() {
    _saveDebouncer?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
