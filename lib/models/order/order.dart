import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/utils/timestamp_converter.dart';

import 'order_item.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String id;
  String? restaurantId;

  @JsonKey(defaultValue: <String>[])
  final List<String> orderedIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> inCartIds;
  @TimestampConverter()
  final DateTime timestamp;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<OrderItem> ordered;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<OrderItem> inCart;

  Order({
    required this.id,
    required this.timestamp,
    this.restaurantId,
    List<String>? orderedIds,
    List<String>? inCartIds,
    List<OrderItem>? ordered,
    List<OrderItem>? inCart,
  }) : ordered = ordered ?? [],
       inCart = inCart ?? [],
       orderedIds = orderedIds ?? (ordered ?? []).map(orderItemRef).toList(),
       inCartIds = inCartIds ?? (inCart ?? []).map(orderItemRef).toList();

    Order.empty() : this(id: '', timestamp: DateTime.now());

  Order copyWith({
    String? id,
    List<String>? orderedIds,
    List<String>? inCartIds,
    List<OrderItem>? ordered,
    List<OrderItem>? inCart,
    DateTime? timestamp,
    String? restaurantId,
  }) {
    return Order(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      orderedIds: orderedIds ?? List<String>.from(this.orderedIds),
      inCartIds: inCartIds ?? List<String>.from(this.inCartIds),
      ordered: ordered ?? List<OrderItem>.from(this.ordered),
      inCart: inCart ?? List<OrderItem>.from(this.inCart),
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (final orderItem in ordered) {
      if (orderItem.orderItemStatus == OrderItemStatus.accepted) {
        totalPrice += orderItem.calculateTotalPrice();
      }
    }
    return totalPrice;
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

String orderItemRef(OrderItem item) =>
    '${item.menuItemId}_${item.sizeName}_${item.quantity}';
