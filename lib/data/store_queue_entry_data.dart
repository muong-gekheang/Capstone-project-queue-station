import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:uuid/uuid.dart';

List<QueueEntry> mockQueueEntries() {
  return [
    QueueEntry(
      id: Uuid().v4(),
      queueNumber: 'A001',
      customerId: 'c001',
      partySize: 2,
      joinTime: DateTime.now().subtract(Duration(minutes: 5)),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.walkIn,
      order: Order(
        id: Uuid().v4(),
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        ordered: [
          OrderItem(
            menuItemId: allMenuItems[0].id, // Classic Burger
            item: allMenuItems[0],
            size: allMenuItems[0].sizes.first.sizeOption, // Small
            addOns: {
              allMenuItems[0].addOns.first.name:
                  allMenuItems[0].addOns.first.price,
            }, // Extra Cheese
            menuItemPrice: allMenuItems[0].sizes.first.price,
            quantity: 1,
            orderItemStatus: OrderItemStatus.pending,
          ),
          OrderItem(
            menuItemId: allMenuItems[4].id, // Cola
            item: allMenuItems[4],
            size: SizeOption(name: 'Medium'), // default size
            addOns: {},
            menuItemPrice: 0.0,
            quantity: 2,
            orderItemStatus: OrderItemStatus.pending,
          ),
        ],
        inCart: [
          OrderItem(
            menuItemId: allMenuItems[0].id, // Classic Burger
            item: allMenuItems[0],
            size: allMenuItems[0].sizes.first.sizeOption, // Small
            addOns: {
              allMenuItems[0].addOns.first.name:
                  allMenuItems[0].addOns.first.price,
            }, // Extra Cheese
            menuItemPrice: allMenuItems[0].sizes.first.price,
            quantity: 1,
            orderItemStatus: OrderItemStatus.pending,
          ),
          OrderItem(
            menuItemId: allMenuItems[4].id, // Cola
            item: allMenuItems[4],
            size: SizeOption(name: 'Medium'), // default size
            addOns: {},
            menuItemPrice: 0.0,
            quantity: 2,
            orderItemStatus: OrderItemStatus.pending,
          ),
        ],
      ),
      tableNumber: 'T1',
    ),
    QueueEntry(
      id: Uuid().v4(),
      queueNumber: 'A002',
      customerId: 'c002',
      partySize: 3,
      joinTime: DateTime.now().subtract(Duration(minutes: 8)),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.remote,
      order: Order(
        id: Uuid().v4(),
        timestamp: DateTime.now().subtract(Duration(minutes: 8)),
        ordered: [],
        inCart: [
          OrderItem(
            menuItemId: allMenuItems[2].id, // Pepperoni Pizza
            item: allMenuItems[2],
            size: allMenuItems[2].sizes[1].sizeOption, // Medium
            addOns: {
              allMenuItems[2].addOns[0].name: allMenuItems[2].addOns[0].price,
            }, // Extra Cheese
            menuItemPrice: allMenuItems[2].sizes[1].price,
            quantity: 1,
            orderItemStatus: OrderItemStatus.pending,
          ),
        ],
      ),
      tableNumber: 'T5',
    ),
    QueueEntry(
      id: Uuid().v4(),
      queueNumber: 'A003',
      customerId: 'c003',
      partySize: 1,
      joinTime: DateTime.now().subtract(Duration(minutes: 2)),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.walkIn,
      order: Order(
        id: Uuid().v4(),
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        ordered: [],
        inCart: [
          OrderItem(
            menuItemId: allMenuItems[1].id, // Cheese Burger
            item: allMenuItems[1],
            size: allMenuItems[1].sizes.first.sizeOption, // Medium
            addOns: {
              allMenuItems[1].addOns[1].name: allMenuItems[1].addOns[1].price,
            }, // Bacon
            menuItemPrice: allMenuItems[1].sizes.first.price,
            quantity: 1,
            orderItemStatus: OrderItemStatus.pending,
          ),
        ],
      ),
      tableNumber: 'T3',
    ),
  ];
}
