import 'package:queue_station_app/model/order_item.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });
}
