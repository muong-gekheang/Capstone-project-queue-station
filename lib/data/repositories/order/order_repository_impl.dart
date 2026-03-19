import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/rendering.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore firestore;

  OrderRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

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
    final doc = await firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;

    return Order.fromJson(doc.data()!);
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
  Stream<List<Order>> watchTodayOrders(String restId) {
    final startOfToday = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      microsecond: 0,
      millisecond: 0,
    );
    final result = firestore
        .collection('orders')
        .where('restId', isEqualTo: restId)
        .where('timestamp', isGreaterThan: startOfToday)
        .snapshots()
        .handleError((err) => debugPrint("Stream Error: $err"))
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            var result = Order.fromJson(doc.data());
            return result;
          }).toList();
        });
    return result;
  }

  @override
  Stream<Order?> watchOrderById(String orderId) {
    // TODO: implement watchOrderById
    throw UnimplementedError();
  }
}
