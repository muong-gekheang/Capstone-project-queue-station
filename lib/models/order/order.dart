import 'package:json_annotation/json_annotation.dart';

import 'order_item.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String id;

  @JsonKey(defaultValue: <String>[])
  final List<String> orderedIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> inCartIds;

  final DateTime timestamp;

  Order({
    required this.id,
    required this.timestamp,
    List<String>? orderedIds,
    List<String>? inCartIds,
  }) : orderedIds = orderedIds ?? [],
       inCartIds = inCartIds ?? [];

  Order copyWith({
    String? id,
    List<String>? orderedIds,
    List<String>? inCartIds,
    DateTime? timestamp,
  }) {
    return Order(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      orderedIds: orderedIds ?? List<String>.from(this.orderedIds),
      inCartIds: inCartIds ?? List<String>.from(this.inCartIds),
    );
  }

  // This should be handle in the ui because right now the attributes represent id not actual objects
  // double calculateTotalPrice() {
  //   double totalPrice = 0;
  //   for (final orderItem in ordered) {
  //     if (orderItem.orderItemStatus == OrderItemStatus.accepted) {
  //       totalPrice += orderItem.calculateTotalPrice();
  //     }
  //   }
  //   return totalPrice;
  // }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
