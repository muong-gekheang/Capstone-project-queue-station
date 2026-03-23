// import 'package:flutter/material.dart';
// import '../models/user/queue_entry.dart';


// List<QueueEntry> mockQueueEntries() {
//   return [
//     QueueEntry(
//       id: 'q1',
//       queueNumber: 'A001',
//       restId: 'r1',
//       customerId: 'c1',
//       partySize: 2,
//       joinTime: DateTime.now().subtract(const Duration(minutes: 10)),
//       status: QueueStatus.waiting,
//       joinedMethod: JoinedMethod.walkIn,
//       order: Order(
//         id: 'o1',
//         timestamp: DateTime.now(),
//         ordered: [
//           OrderItem(
//             menuItemId: 'm1',
//             menuItemPrice: 5.0,
//             quantity: 1,
//             orderItemStatus: OrderItemStatus.pending,
//             addOns: {'Cheese': 1.0},
//             sizeName: 'Medium',
//           ),
//           OrderItem(
//             menuItemId: 'm2',
//             menuItemPrice: 2.0,
//             quantity: 2,
//             orderItemStatus: OrderItemStatus.pending,
//           ),
//         ],
//         inCart: [
//           OrderItem(
//             menuItemId: 'm3',
//             menuItemPrice: 3.5,
//             quantity: 1,
//             orderItemStatus: OrderItemStatus.pending,
//           ),
//         ],
//       ),
//     ),

//     QueueEntry(
//       id: 'q2',
//       queueNumber: 'A002',
//       restId: 'r1',
//       customerId: 'c2',
//       partySize: 4,
//       joinTime: DateTime.now().subtract(const Duration(minutes: 5)),
//       status: QueueStatus.waiting,
//       joinedMethod: JoinedMethod.remote,
//       order: Order(
//         id: 'o2',
//         ordered: [
//           OrderItem(
//             menuItemId: 'm4',
//             menuItemPrice: 8.0,
//             quantity: 1,
//             orderItemStatus: OrderItemStatus.pending,
//             addOns: {'Extra sauce': 0.5},
//           ),
//         ],
//         timestamp: DateTime.now(),
//         inCart: [],
//       ),
//     ),
//   ];
// }

// enum NotificationStatus { read, unread }

// class StoreOrderNotificationProvider with ChangeNotifier {
//   final List<QueueEntry> _queueEntries = [];

//   List<QueueEntry> get queueEntries => List.unmodifiable(_queueEntries);

//   StoreOrderNotificationProvider() {
//     _queueEntries.addAll(mockQueueEntries());
//     print('Initialized with ${_queueEntries.length} orders');
//   }

//   void addIncomingOrder(QueueEntry entry) {
//     _queueEntries.add(
//       entry.copyWith(
//         order: entry.order?.copyWith(
//           ordered: entry.order!.ordered.map((item) => item.copyWith()).toList(),
//           inCart: entry.order!.inCart.map((item) => item.copyWith()).toList(),
//         ),
//       ),
//     );
//     notifyListeners();
//   }

//   void acceptAllIncomingOrder(QueueEntry entry) {
//     final index = _queueEntries.indexWhere((e) => e.id == entry.id);
//     if (index == -1) return;

//     final oldEntry = _queueEntries[index];
//     final order = oldEntry.order;
//     if (order == null) return;

//     final updatedItems = order.ordered.map((item) {
//       return item.copyWith(orderItemStatus: OrderItemStatus.accepted);
//     }).toList();

//     _queueEntries[index] = oldEntry.copyWith(
//       order: order.copyWith(ordered: updatedItems),
//     );

//     notifyListeners();
//   }

//   void rejectIncomingOrder(QueueEntry entry, OrderItem item) {
//     final index = _queueEntries.indexOf(entry);
//     if (index == -1) return;

//     final oldEntry = _queueEntries[index];
//     final order = oldEntry.order;
//     if (order == null) return;

//     final updatedOrder = order.copyWith(
//       inCart: order.inCart.where((i) => i != item).toList(),
//     );

//     _queueEntries[index] = oldEntry.copyWith(order: updatedOrder);
//     notifyListeners();
//   }
// }

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
