import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/services/order_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final OrderService _orderService;

  StreamSubscription<List<Order>>? _orderSubscription;

  List<Order> currentOrders = [];

  NotificationViewModel({required OrderService orderService})
    : _orderService = orderService;

  void subscribe() {
    _orderSubscription = _orderService.streamTodayOrders.listen((data) {});
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }
}
