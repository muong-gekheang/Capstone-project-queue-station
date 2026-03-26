import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';

class StoreOrderViewModel extends ChangeNotifier {
  final QueueService _queueService;
  final OrderService _orderService;

  bool _isDisposed = false;

  List<QueueEntry> _currentQueue = [];
  bool _isLoading = true;

  StreamSubscription<List<QueueEntry>>? _queueEntriesSubscription;

  StoreOrderViewModel({
    required QueueService queueService,
    required OrderService orderService,
  }) : _queueService = queueService,
       _orderService = orderService {
    _subscribeToQueueEntries();
  }

  void _subscribeToQueueEntries() {
    _queueEntriesSubscription = _queueService.streamQueueEntries.listen(
      (queueEntries) {
        if (_isDisposed) return;
        queueEntries.sort(
          (a, b) => a.expectedTableReadyAt.compareTo(b.expectedTableReadyAt),
        );
        _currentQueue = queueEntries;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _queueEntriesSubscription?.cancel();
    _isDisposed = true;

    super.dispose();
  }

  bool get isLoading => _isLoading;

  List<QueueEntry> get currentQueue => _currentQueue;

  QueueEntry? getQueueEntryById(String id) {
    try {
      return _currentQueue.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Order?> getOrderDetailsById(String orderId) async {
    return await _orderService.getOrderDetailsById(orderId);
  }

  /// Accept all pending items for [queueEntry]'s order and send the customer
  /// a notification with their queue position via a Cloud Function.
  Future<void> acceptOrderAndNotifyCustomer(QueueEntry queueEntry) async {
    if (queueEntry.orderId == null) return;

    final callable = FirebaseFunctions.instance.httpsCallable(
      'acceptOrderAndNotifyCustomer',
    );

    await callable.call({
      'orderId': queueEntry.orderId,
      'queueEntryId': queueEntry.id,
      'restaurantId': queueEntry.restId,
      'customerId': queueEntry.customerId,
    });
  }
}
