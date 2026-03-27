import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

abstract class OrderRepository {
  Future<void> create(Order order);
  Future<String> createEmptyOrder({
    required String restaurantId,
    required String queueEntryId,
  });
  Future<Order?> getOrderById(String orderId);
  Future<Order> update(Order order);
  Future<void> delete(String orderId);
  Future<void> updateOrderedItemStatus(
    String orderId,
    String menuItemId,
    OrderItemStatus status,
  );
  Future<void> confirmOrder(String orderId);

  Future<OrderItem?> getOrderItemById(String orderId, String orderedId);
  Future<void> saveOrder(Order order);
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Stream<Order?> watchOrderById(String orderId);
  Stream<List<Order>> watchAllOrder();
  //Stream<Order?> watchCurrentOrder(String orderId);
  Stream<List<Order>> watchTodayOrders(String restId);
  Stream<List<OrderItem>> watchOrderItems(String orderId);
  
}
