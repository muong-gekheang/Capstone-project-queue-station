import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_mock.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

enum NotificationStatus { read, unread }

class StoreOrderNotificationProvider extends ChangeNotifier {
  final List<QueueEntry> _queueEntries = [];

  List<QueueEntry> get queueEntries => List.unmodifiable(_queueEntries);

  StoreOrderNotificationProvider() {
    _queueEntries.addAll(mockQueueEntries);
    print('Initialized with ${_queueEntries.length} orders');
  }

  /// Adds a new incoming order to the notification list.
  void addIncomingOrder(QueueEntry entry) {
    _queueEntries.add(entry);
    notifyListeners();
  }

  /// Accepts all items in the order and removes the notification.
  /// (In a real app you would update the order status; here we simply remove it.)
  void acceptAllIncomingOrder(QueueEntry entry) {
    _queueEntries.removeWhere((e) => e.id == entry.id);
    notifyListeners();
  }

  /// Rejects (or dismisses) an incoming order notification.
  void rejectIncomingOrder(QueueEntry entry) {
    _queueEntries.removeWhere((e) => e.id == entry.id);
    notifyListeners();
  }
}
