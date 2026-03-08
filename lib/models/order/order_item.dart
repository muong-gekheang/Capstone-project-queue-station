import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

enum OrderItemStatus { pending, accepted, rejected, cancelled }

@JsonSerializable(explicitToJson: true)
class OrderItem {
  final String menuItemId;
  final List<String> addOnsId;
  final double menuItemPrice;
  final String sizeName;
  final int quantity;
  final String? note;
  final OrderItemStatus orderItemStatus;

  OrderItem({
    required this.menuItemId,
    required this.menuItemPrice,
    required this.quantity,
    this.note,
    required this.orderItemStatus,
    List<String>? addOnsId,
    required this.sizeName,
  }) : addOnsId = addOnsId ?? []; 

  OrderItem copyWith({
    String? menuItemId,
    List<String>? addOnsId, 
    double? menuItemPrice,
    String? sizeName,
    int? quantity,
    String? note,
    OrderItemStatus? orderItemStatus,
  }) {
    return OrderItem(
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemPrice: menuItemPrice ?? this.menuItemPrice,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      orderItemStatus: orderItemStatus ?? this.orderItemStatus,
      addOnsId: addOnsId ?? List.from(this.addOnsId), // ✓ matches field
      sizeName: sizeName ?? this.sizeName,
    );
  }

  double calculateTotalPrice() {
    return menuItemPrice * quantity;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
