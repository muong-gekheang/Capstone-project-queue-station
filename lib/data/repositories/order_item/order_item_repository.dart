import 'package:queue_station_app/models/order/order_item.dart';

abstract class OrderItemRepository {
  Future<void> create(OrderItem orderItem);
  Future<void> delete(String orderItemId);
  Future<OrderItem> update(OrderItem orderItem);
  Future<List<OrderItem>> getOrderItemByOrderId(String orderId);
}
