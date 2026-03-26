import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import '../models/user/queue_entry.dart';

enum NotificationStatus { read, unread }

class StoreOrderNotificationProvider with ChangeNotifier {
  final List<QueueEntry> _queueEntries = [];

  List<QueueEntry> get queueEntries => List.unmodifiable(_queueEntries);

  StoreOrderNotificationProvider();

  void addIncomingOrder(QueueEntry entry) {
    _queueEntries.add(
      entry.copyWith(
        order: entry.order?.copyWith(
          ordered: entry.order!.ordered.map((item) => item.copyWith()).toList(),
          inCart: entry.order!.inCart.map((item) => item.copyWith()).toList(),
        ),
      ),
    );
    notifyListeners();
  }

  void acceptAllIncomingOrder(QueueEntry entry) {
    final index = _queueEntries.indexWhere((e) => e.id == entry.id);
    if (index == -1) return;

    final oldEntry = _queueEntries[index];
    final order = oldEntry.order;
    if (order == null) return;

    final updatedItems = order.ordered.map((item) {
      return item.copyWith(orderItemStatus: OrderItemStatus.accepted);
    }).toList();

    _queueEntries[index] = oldEntry.copyWith(
      order: order.copyWith(ordered: updatedItems),
    );

    notifyListeners();
  }

  void rejectIncomingOrder(QueueEntry entry, OrderItem item) {
    final index = _queueEntries.indexOf(entry);
    if (index == -1) return;

    final oldEntry = _queueEntries[index];
    final order = oldEntry.order;
    if (order == null) return;

    final updatedOrder = order.copyWith(
      inCart: order.inCart.where((i) => i != item).toList(),
    );

    _queueEntries[index] = oldEntry.copyWith(order: updatedOrder);
    notifyListeners();
  }
}
