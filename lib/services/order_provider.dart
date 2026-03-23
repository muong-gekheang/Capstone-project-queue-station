import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/services/user_provider.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository orderRepository;
  UserProvider userProvider;

  Order _currentOrder;

  StreamSubscription<Order?>? _orderSubscription;
  Timer? _debounce;

  bool _isSyncing = false;
  bool _isConfirming = false;

  OrderProvider({
    required Order currentOrder,
    required this.orderRepository,
    required this.userProvider,
  }) : _currentOrder = currentOrder;

  // ---------------------------
  // Getters
  // ---------------------------

  Order get currentOrder => _currentOrder;

  List<OrderItem> get items => List.unmodifiable(_currentOrder.inCart);

  bool get isSyncing => _isSyncing;

  bool get isConfirming => _isConfirming;

  int get totalItemsCount {
    return _currentOrder.inCart.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _currentOrder.inCart.fold(0.0, (sum, item) {
      final addOnsTotal = item.addOns.values.fold(0.0, (a, b) => a + b);
      return sum + (item.menuItemPrice + addOnsTotal) * item.quantity;
    });
  }

<<<<<<< HEAD
  // ---------------------------
  // Firestore Listener
  // ---------------------------

  void startOrderListener() {
    final orderId = _currentOrder.id;

    if (orderId.isEmpty) return;

    _orderSubscription?.cancel();

    _orderSubscription = orderRepository.watchCurrentOrder(orderId).listen((
      updatedOrder,
    ) {
      if (updatedOrder == null) return;

      _mergeFirestoreOrder(updatedOrder);
    });
  }

  void _mergeFirestoreOrder(Order firestoreOrder) {
    _currentOrder = firestoreOrder.copyWith(
      inCart: _currentOrder.inCart,
      ordered: _currentOrder.ordered,
=======
  Order _createNewOrder() {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      restaurantId: '',
>>>>>>> origin/store-side_mvvm
    );

    notifyListeners();
  }

  // ---------------------------
  // Cart Operations
  // ---------------------------

  void addToCart(OrderItem newItem) {
    final cart = [..._currentOrder.inCart];

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

    _currentOrder = _currentOrder.copyWith(inCart: cart);

    notifyListeners();

    _scheduleSync();
  }

  void removeItem(OrderItem target) {
    final cart = _currentOrder.inCart
        .where(
          (item) =>
              !(item.menuItemId == target.menuItemId &&
                  item.size.name == target.size.name &&
                  _mapEquals(item.addOns, target.addOns)),
        )
        .toList();

    _currentOrder = _currentOrder.copyWith(inCart: cart);

    notifyListeners();

    _scheduleSync();
  }

  void updateCartItem(OrderItem oldItem, OrderItem updatedItem) {
    final cart = [..._currentOrder.inCart];

    final index = cart.indexOf(oldItem);

    if (index != -1) {
      cart[index] = updatedItem;

      _currentOrder = _currentOrder.copyWith(inCart: cart);

      notifyListeners();

      _scheduleSync();
    }
  }

  void clearCart() {
    _currentOrder = _currentOrder.copyWith(inCart: []);

    notifyListeners();

    _scheduleSync();
  }

  void updateUserProvider(UserProvider newUserProvider) {
    userProvider = newUserProvider;

    final historyId = userProvider.asCustomer?.currentHistoryId;

    if (historyId != null) {
      startOrderListener();
    }
  }

  // ---------------------------
  // Confirm Order
  // ---------------------------

  Future<void> confirmCurrentOrder() async {
    if (_isConfirming) return;

    if (_currentOrder.inCart.isEmpty || _currentOrder.id.isEmpty) return;

    _isConfirming = true;
    notifyListeners();

    try {
      await orderRepository.confirmOrder(_currentOrder.id);

      _currentOrder = _currentOrder.copyWith(
        ordered: [..._currentOrder.ordered, ..._currentOrder.inCart],
        inCart: [],
      );
    } catch (e) {
      debugPrint("Confirm Error: $e");
    } finally {
      _isConfirming = false;
      notifyListeners();
    }
  }

  // ---------------------------
  // Firestore Sync
  // ---------------------------

  void _scheduleSync() {
    final queueId = userProvider.asCustomer?.currentHistoryId;

    if (queueId == null) return;

    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 2), () async {
      try {
        _isSyncing = true;
        notifyListeners();

        final newOrderId = await orderRepository.syncCart(
          queueEntryId: queueId,
          order: _currentOrder,
        );

        if (_currentOrder.id.isEmpty && newOrderId != null) {
          _currentOrder = _currentOrder.copyWith(id: newOrderId);

          startOrderListener();
        }
      } catch (e) {
        debugPrint("Sync Error: $e");
      } finally {
        _isSyncing = false;
        notifyListeners();
      }
    });
  }

  // ---------------------------
  // Utility
  // ---------------------------

  bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }

    return true;
  }

  // ---------------------------
  // Dispose
  // ---------------------------

  @override
  void dispose() {
    _orderSubscription?.cancel();
    _debounce?.cancel();

    super.dispose();
  }
}
