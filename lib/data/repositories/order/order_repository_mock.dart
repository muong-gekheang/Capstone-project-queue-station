import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:uuid/uuid.dart';

class OrderRepositoryMock implements OrderRepository {
  Map<String, Order> orders = {};

  OrderRepositoryMock() {
    for (var order in mockOrders) {
      orders[order.id] = order;
    }
  }
  @override
  Future<void> addItemToCart(String orderId, OrderItem item) {
    // TODO: implement addItemToCart
    throw UnimplementedError();
  }

  @override
  Future<void> create(Order order) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String orderId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Order?> getOrderById(String orderId) async {
    return orders[orderId];
  }

  @override
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchOrders(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getSearchOrders
    throw UnimplementedError();
  }

  @override
  Future<void> moveItemToOrdered(String orderId, String menuItemId) {
    // TODO: implement moveItemToOrdered
    throw UnimplementedError();
  }

  @override
  Future<void> removeItemFromCart(String orderId, String menuItemId) {
    // TODO: implement removeItemFromCart
    throw UnimplementedError();
  }

  @override
  Future<void> removeOrderedItem(String orderId, String menuItemId) {
    // TODO: implement removeOrderedItem
    throw UnimplementedError();
  }

  @override
  Future<Order> update(Order order) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> updateCartItem(String orderId, OrderItem item) {
    // TODO: implement updateCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrderedItemStatus(
    String orderId,
    String menuItemId,
    OrderItemStatus status,
  ) {
    // TODO: implement updateOrderedItemStatus
    throw UnimplementedError();
  }

  @override
  Stream<Order?> watchOrderById(String orderId) {
    // TODO: implement watchOrderById
    throw UnimplementedError();
  }

  @override
  Stream<List<Order>> watchAllOrder(String restId) {
    // TODO: implement watchAllOrder
    throw UnimplementedError();
  }
}

List<Order> mockOrders = [
  Order(
    id: Uuid().v4(),
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ordered: [],
    inCart: [
      OrderItem(
        menuItemId: mockMenuItems[0].id, // Classic Burger
        item: mockMenuItems[0],
        size: mockMenuItems[0].sizes.first.sizeOption, // Small
        addOns: {
          mockMenuItems[0].addOns.first.name:
              mockMenuItems[0].addOns.first.price,
        }, // Extra Cheese
        menuItemPrice: mockMenuItems[0].sizes.first.price,
        quantity: 1,
        orderItemStatus: OrderItemStatus.pending,
        orderId: '',
      ),
      OrderItem(
        menuItemId: mockMenuItems[4].id, // Cola
        item: mockMenuItems[4],
        size: SizeOption(
          name: 'Medium',
          id: '',
          restaurantId: '',
        ), // default size
        addOns: {},
        menuItemPrice: 0.0,
        quantity: 2,
        orderItemStatus: OrderItemStatus.pending,
        orderId: '',
      ),
    ],
    restaurantId: '',
  ),
  Order(
    id: Uuid().v4(),
    timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    ordered: [],
    inCart: [
      OrderItem(
        menuItemId: mockMenuItems[1].id, // Cheese Burger
        item: mockMenuItems[1],
        size: mockMenuItems[1].sizes.first.sizeOption, // Medium
        addOns: {
          mockMenuItems[1].addOns[1].name: mockMenuItems[1].addOns[1].price,
        }, // Bacon
        menuItemPrice: mockMenuItems[1].sizes.first.price,
        quantity: 1,
        orderItemStatus: OrderItemStatus.pending,
        orderId: '',
      ),
    ],
    restaurantId: '',
  ),
];
