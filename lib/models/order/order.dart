import 'order_item.dart';

class Order {
  final String id;
  final List<OrderItem> ordered;
  final List<OrderItem> inCart;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.timestamp,
    List<OrderItem>? ordered,
    List<OrderItem>? inCart,
  }) : ordered = ordered ?? [],
       inCart = inCart ?? [];

  Order copyWith({
    String? id,
    List<OrderItem>? ordered,
    List<OrderItem>? inCart,
    DateTime? timestamp,
  }) {
    return Order(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      ordered: ordered != null ? List.from(ordered) : List.from(this.ordered),
      inCart: inCart != null ? List.from(inCart) : List.from(this.inCart),
    );
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (OrderItem orderItem in ordered) {
      if (orderItem.orderItemStatus == OrderItemStatus.accepted) {
        totalPrice += orderItem.calculateTotalPrice();
      }
    }
    return totalPrice;
  }
}
