import 'order_item.dart';

class Order {
  final String id;
  final List<OrderItem> ordered = [];
  final List<OrderItem> inCart = []; // No storing in the DB
  final DateTime timestamp;

  Order({required this.id, required this.timestamp});
}
