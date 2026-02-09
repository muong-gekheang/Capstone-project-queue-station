import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';

class OrderProvider with ChangeNotifier {
  Order? _currentOrder;
  final List<Order> _orders = [];

  Order get currentOrder {
    _currentOrder ??= _createNewOrder();
    return _currentOrder!;
  }

  Order _createNewOrder() {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );
    _orders.add(order);
    return order;
  }

  void confirmCurrentOrder() {
    if (_currentOrder == null) return;

    _currentOrder!.ordered.addAll(_currentOrder!.inCart);
    _currentOrder!.inCart.clear();

    _currentOrder = _createNewOrder();
    notifyListeners();
  }
}
