import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class OrderProvider with ChangeNotifier {
  Order? _currentOrder;
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Order get currentOrder {
    _currentOrder ??= _createNewOrder();
    return _currentOrder!;
  }

  Order? get lastConfirmedOrder {
    if (_orders.isEmpty) return null;
    return _orders.last;
  }

  Order _createNewOrder() {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );
  }

  void confirmCurrentOrder() {
    if (_currentOrder == null) return;

    _currentOrder!.ordered.addAll(_currentOrder!.inCart);
    _currentOrder!.inCart.clear();

    _orders.add(_currentOrder!);

    _currentOrder = _createNewOrder();
    notifyListeners();
  }

}
