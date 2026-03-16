import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

class OrderRepositoryImpl implements OrderRepository {
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
  Future<Order?> getOrderById(String orderId) {
    // TODO: implement getOrderById
    throw UnimplementedError();
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
  Stream<List<Order>> watchAllOrder(String restId) {
    // TODO: implement watchAllOrder
    throw UnimplementedError();
  }

  @override
  Stream<Order?> watchOrderById(String orderId) {
    // TODO: implement watchOrderById
    throw UnimplementedError();
  }
}
