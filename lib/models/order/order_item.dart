import 'package:json_annotation/json_annotation.dart';

import '../restaurant/menu_item.dart';
import '../restaurant/menu_item_category.dart';
import '../restaurant/size_option.dart';

part 'order_item.g.dart';

enum OrderItemStatus { pending, accepted, rejected, cancelled }

@JsonSerializable(explicitToJson: true)
class OrderItem {
  final String menuItemId;
  final String id;

  @JsonKey(fromJson: _addOnsFromJson, toJson: _addOnsToJson)
  final Map<String, double> addOns;

  final double menuItemPrice;
  final String sizeName;
  final int quantity;
  final String? note;
  final OrderItemStatus orderItemStatus;
  String orderId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final MenuItem item;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final SizeOption size;

  OrderItem({
    required this.menuItemId,
    required this.menuItemPrice,
    required this.quantity,
    this.note,
    required this.orderItemStatus,
    required this.orderId,
    Map<String, double>? addOns,
    String? sizeName,
    MenuItem? item,
    SizeOption? size,
    required this.id,
  }) : addOns = addOns ?? {},
       sizeName = sizeName ?? size?.name ?? 'Regular',
       item = item ?? _placeholderMenuItem(menuItemId),
       size =
           size ??
           SizeOption(name: sizeName ?? 'Regular', id: '', restaurantId: '');

  OrderItem copyWith({
    String? menuItemId,
    String? orderId,
    Map<String, double>? addOns,
    double? menuItemPrice,
    String? sizeName,
    SizeOption? size,
    MenuItem? menuItem,
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
      addOns: addOns != null ? Map.from(addOns) : Map.from(this.addOns),
      sizeName: sizeName ?? this.sizeName,
      size: size ?? this.size,
      item: item ?? this.item,
      orderId: orderId ?? this.orderId,
      id: id,
    );
  }

  double calculateTotalPrice() {
    double totalPrice = menuItemPrice;
    totalPrice += addOns.values.fold(0.0, (sum, price) => sum + price);
    totalPrice *= quantity;
    return totalPrice;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

Map<String, double> _addOnsFromJson(Map<String, dynamic> json) {
  return json.map((key, value) => MapEntry(key, (value as num).toDouble()));
}

Map<String, dynamic> _addOnsToJson(Map<String, double> addOns) {
  return addOns;
}

MenuItem _placeholderMenuItem(String menuItemId) {
  return MenuItem(
    id: menuItemId,
    name: 'Unknown item',
    description: '',
    category: MenuItemCategory(id: 'unknown_category', name: 'Unknown'),
    restaurantId: '',
  );
}
