<<<<<<< HEAD
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:queue_station_app/data/repositories/order/order_repository.dart';
// import 'package:queue_station_app/models/order/order_item.dart';
// import 'package:queue_station_app/models/order/order.dart' as order_model;

// class OrderRepositoryMock implements OrderRepository{
//   final Map<String, order_model.Order> _orders = {};

//   // ignore: prefer_final_fields
//   order_model.Order _currentOrder = order_model.Order(
//     id: DateTime.now().millisecondsSinceEpoch.toString(),
//     inCart: [],
//     ordered: [],
//     timestamp: DateTime.now(),
//   );

//   @override
//   order_model.Order get currentOrder => _currentOrder;
  
//   @override
//   Future<void> addItemToCart(String orderId, OrderItem item) async {
//     if (_currentOrder.id != orderId) return;

//     final index = _currentOrder.inCart.indexWhere(
//       (existing) =>
//           existing.menuItemId == item.menuItemId &&
//           existing.size.name == item.size.name &&
//           _mapEquals(existing.addOns, item.addOns),
//     );

//     if (index != -1) {
//       final existing = _currentOrder.inCart[index];
//       _currentOrder.inCart[index] = OrderItem(
//         menuItemId: existing.menuItemId,
//         item: existing.item,
//         addOns: existing.addOns,
//         menuItemPrice: existing.menuItemPrice,
//         size: existing.size,
//         note: existing.note,
//         quantity: existing.quantity + item.quantity,
//         orderItemStatus: OrderItemStatus.pending,
//       );
//     } else {
//       _currentOrder.inCart.add(item);
//     }
//   }

//   @override
//   Future<void> create(order_model.Order order) async{
//     _orders[order.id] = order;
//   }

//   @override
//   Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)>
//   getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) async {
//     final allOrders = _orders.values.toList();
//     return (allOrders.take(limit).toList(), null);
//   }


//   @override
//   Future<order_model.Order?> getOrderById(String orderId) async{
//     return _orders[orderId];
//   }

//   @override
//   Future<void> removeItemFromCart(String orderId, String menuItemId) async {
//     if (_currentOrder.id != orderId) return;
//     _currentOrder.inCart.removeWhere((item) => item.menuItemId == menuItemId);
//   }

//   /// Confirm current order (move cart to ordered)
//   @override
//   Future<order_model.Order> update(order_model.Order order) async {
//     order.ordered.addAll(order.inCart);
//     order.inCart.clear();

//     _orders[order.id] = order;

//     // Create new cart
//     _currentOrder = order_model.Order(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       inCart: [],
//       ordered: [],
//       timestamp: DateTime.now(),
//     );

//     return order;
//   }


//   @override
//   Future<void> delete(String orderId) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> removeOrderedItem(String orderId, String menuItemId) {
//     // TODO: implement removeOrderedItem
//     throw UnimplementedError();
//   }

//   @override
//   Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)>
//   getSearchOrders(
//     String query,
//     int limit,
//     DocumentSnapshot<Map<String, dynamic>>? lastDoc,
//   ) {
//     // TODO: implement getSearchOrders
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> moveItemToOrdered(String orderId, String menuItemId) {
//     // TODO: implement moveItemToOrdered
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> updateCartItem(String orderId, OrderItem item) {
//     // TODO: implement updateCartItem
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> updateOrderedItemStatus(String orderId, String menuItemId, OrderItemStatus status) {
//     // TODO: implement updateOrderedItemStatus
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<order_model.Order>> watchAllOrder() {
//     // TODO: implement watchAllOrder
//     throw UnimplementedError();
//   }

//   @override
//   Stream<order_model.Order?> watchOrderById(String orderId) {
//     // TODO: implement watchOrderById
//     throw UnimplementedError();
//   }

//   bool _mapEquals(Map<String, double> a, Map<String, double> b) {
//     if (a.length != b.length) return false;
//     for (final key in a.keys) {
//       if (!b.containsKey(key) || b[key] != a[key]) return false;
//     }
//     return true;
//   }

// }
=======
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
  Stream<List<Order>> watchTodayOrders(String restId) {
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
        id: '',
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
        id: '',
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
        id: '',
      ),
    ],
    restaurantId: '',
  ),
];
>>>>>>> origin/store-side_mvvm
