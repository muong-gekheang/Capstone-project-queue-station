import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

abstract class OrderRepository {
  Future<void> create(Order order);
  Future<Order?> getOrderById(String orderId);
  Future<Order> update(Order order);
  Future<void> delete(String orderId);
  Order get currentOrder;
  Future<void> confirmOrder(String orderId);

  Future<OrderItem?> getOrderItemById(String orderId, String orderedId);
  Future<void> addItemToCart(String orderId, OrderItem item);
  Future<void> updateCartItem(String orderId, OrderItem item);
  Future<void> removeItemFromCart(String orderId, OrderItem item);

  Future<void> moveItemToOrdered(String orderId, OrderItem item);
  Future<void> updateOrderedItemStatus(
    String orderId,
    String menuItemId,
    OrderItemStatus status,
  );

  Future<String?> syncCart({required String queueEntryId, required Order order});

  Future<void> removeOrderedItem(String orderId, String menuItemId);

  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchOrders(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );

  Stream<Order?> watchOrderById(String orderId);
  Stream<List<Order>> watchAllOrder();
  Stream<Order?> watchCurrentOrder(String orderId);
}
