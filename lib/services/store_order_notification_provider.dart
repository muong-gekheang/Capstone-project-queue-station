import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import '../models/user/queue_entry.dart';

final List<QueueEntry> mockQueueEntries = [
  // Walk-in customer with an order
  QueueEntry.walkIn(
    id: 'q1',
    queueNumber: 'A001',
    restId: 'r1',
    customerId: 'c1',
    assignedTableId: 't1',
    partySize: 2,
    joinTime: DateTime.now().subtract(const Duration(minutes: 10)),
    expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 5)),
    status: QueueStatus.waiting,
    customerName: 'Alice',
    phoneNumber: '0123456789',
    tableNumber: 'T1',
    order: Order(
      id: 'o1',
      timestamp: DateTime.now(),
      ordered: [
        OrderItem(
          id: 'oi1',
          menuItemId: 'm1',
          menuItemPrice: 5.0,
          quantity: 1,
          orderItemStatus: OrderItemStatus.pending,
          addOns: {'Cheese': 1.0},
          orderId: 'o1',
          sizeName: 'Medium',
        ),
        OrderItem(
          id: 'oi2',
          menuItemId: 'm2',
          menuItemPrice: 3.0,
          quantity: 2,
          orderItemStatus: OrderItemStatus.pending,
          orderId: 'o1',
        ),
      ],
      inCart: [
        OrderItem(
          id: 'oi3',
          menuItemId: 'm3',
          menuItemPrice: 2.5,
          quantity: 1,
          orderItemStatus: OrderItemStatus.pending,
          orderId: 'o1',
        ),
      ],
    ),
  ),

  // Remote customer with order
  QueueEntry(
    id: 'q2',
    queueNumber: 'A002',
    restId: 'r1',
    customerId: 'c2',
    assignedTableId: 't2',
    partySize: 4,
    joinTime: DateTime.now().subtract(const Duration(minutes: 5)),
    expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 15)),
    status: QueueStatus.waiting,
    joinedMethod: JoinedMethod.remote,
    orderId: 'o2',
    order: Order(
      id: 'o2',
      timestamp: DateTime.now(),
      ordered: [
        OrderItem(
          id: 'oi4',
          menuItemId: 'm4',
          menuItemPrice: 8.0,
          quantity: 1,
          orderItemStatus: OrderItemStatus.pending,
          addOns: {'Extra sauce': 0.5},
          orderId: 'o2',
        ),
      ],
      inCart: [],
    ),
  ),

  // Walk-in customer without order yet
  QueueEntry.walkIn(
    id: 'q3',
    queueNumber: 'A003',
    restId: 'r1',
    customerId: 'c3',
    assignedTableId: 't3',
    partySize: 3,
    joinTime: DateTime.now().subtract(const Duration(minutes: 2)),
    expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 10)),
    status: QueueStatus.waiting,
    customerName: 'Bob',
    phoneNumber: '0987654321',
    tableNumber: 'T3',
    order: Order.empty(),
  ),
];


enum NotificationStatus { read, unread }

class StoreOrderNotificationProvider with ChangeNotifier {
  final List<QueueEntry> _queueEntries = [];

  List<QueueEntry> get queueEntries => List.unmodifiable(_queueEntries);

  StoreOrderNotificationProvider() {
    _queueEntries.addAll(mockQueueEntries);
    print('Initialized with ${_queueEntries.length} orders');
  }

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
