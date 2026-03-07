import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_mock.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

enum NotificationStatus { read, unread }

class StoreOrderNotificationProvider with ChangeNotifier {
  final List<QueueEntry> _queueEntries = [];
  final OrderRepository _orderRepository;

  List<QueueEntry> get queueEntries => List.unmodifiable(_queueEntries);

  StoreOrderNotificationProvider({required OrderRepository orderRepository})
    : _orderRepository = orderRepository {
    _queueEntries.addAll(mockQueueEntries);
    print('Initialized with ${_queueEntries.length} orders');
  }

  Future<void> addIncomingOrder(QueueEntry entry) async {
    notifyListeners();
  }

  void acceptAllIncomingOrder(QueueEntry entry) {
    // final index = _queueEntries.indexWhere((e) => e.id == entry.id);
    // if (index == -1) return;

    // final oldEntry = _queueEntries[index];
    // final order = oldEntry.order;
    // if (order == null) return;

    // final updatedItems = order.ordered.map((item) {
    //   return item.copyWith(orderItemStatus: OrderItemStatus.accepted);
    // }).toList();

    // _queueEntries[index] = oldEntry.copyWith(
    //   order: order.copyWith(ordered: updatedItems),
    // );

    // notifyListeners();
  }

  void rejectIncomingOrder(QueueEntry entry, OrderItem item) {
    // final index = _queueEntries.indexOf(entry);
    // if (index == -1) return;

    // final oldEntry = _queueEntries[index];
    // final order = oldEntry.order;
    // if (order == null) return;

    // final updatedOrder = order.copyWith(
    //   inCart: order.inCart.where((i) => i != item).toList(),
    // );

    // _queueEntries[index] = oldEntry.remoteCopyWith(order: updatedOrder);
    // _queueEntries[index] = oldEntry.remoteCopyWith(order: updatedOrder);
    // notifyListeners();
  }
}
