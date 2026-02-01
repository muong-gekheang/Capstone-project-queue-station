import 'package:queue_station_app/model/entities/store_queue_history.dart';

final order1 = OrderDetail(menuName: 'Americano', quantity: 2, unitPrice: 2.50);

final order2 = OrderDetail(menuName: 'Croissant', quantity: 1, unitPrice: 1.80);

final order3 = OrderDetail(menuName: 'Latte', quantity: 1, unitPrice: 3.20);

final List<StoreQueueHistory> mockQueueHistories = [
  StoreQueueHistory(
      customerName: 'Alex Tan',
      currentStatus: Status.serving,
      queueNumber: 'A12',
      joinedMethod: JoinedMethod.walkIn,
      numberOfGuests: 2,
      joinedQueueTime: DateTime(2026, 1, 26, 10, 15, 30),
      seatedTime: DateTime(2026, 1, 26, 10, 22, 10),
      endedTime: DateTime(2026, 1, 26, 11, 0, 0),
    )
    ..addNewOrder(order1)
    ..addNewOrder(order2)
    ..addNewOrder(order3),

  StoreQueueHistory(
      customerName: 'Sokha Lim',
      currentStatus: Status.completed,
      queueNumber: 'B03',
      joinedMethod: JoinedMethod.remotely,
      numberOfGuests: 4,
      joinedQueueTime: DateTime(2026, 1, 26, 11, 5, 0),
      seatedTime: DateTime(2026, 1, 26, 11, 12, 30),
      endedTime: DateTime(2026, 1, 26, 12, 0, 0),
    )
    ..addNewOrder(order1)
    ..addNewOrder(order2)
    ..addNewOrder(order3),

  StoreQueueHistory(
      customerName: 'Dara Chen',
      currentStatus: Status.noShow,
      queueNumber: 'C08',
      joinedMethod: JoinedMethod.walkIn,
      numberOfGuests: 1,
      joinedQueueTime: DateTime(2026, 1, 26, 12, 20, 0),
      seatedTime: DateTime(2026, 1, 26, 12, 20, 0),
      endedTime: DateTime(2026, 1, 26, 12, 35, 0),
    )
    ..addNewOrder(order1)
    ..addNewOrder(order2)
    ..addNewOrder(order3),

  StoreQueueHistory(
      customerName: 'Mina Park',
      currentStatus: Status.cancelled,
      queueNumber: 'D01',
      joinedMethod: JoinedMethod.remotely,
      numberOfGuests: 3,
      joinedQueueTime: DateTime(2026, 1, 26, 13, 0, 0),
      seatedTime: DateTime(2026, 1, 26, 13, 0, 0),
      endedTime: DateTime(2026, 1, 26, 13, 10, 0),
    )
    ..addNewOrder(order1)
    ..addNewOrder(order2)
    ..addNewOrder(order3),
];
