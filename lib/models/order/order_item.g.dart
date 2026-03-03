// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  quantity: (json['quantity'] as num).toInt(),
  note: json['note'] as String?,
  item: MenuItem.fromJson(json['item'] as Map<String, dynamic>),
  addOns: _addOnsFromJson(json['addOns'] as Map<String, dynamic>),
  menuItemId: json['menuItemId'] as String,
  menuItemPrice: (json['menuItemPrice'] as num).toDouble(),
  size: SizeOption.fromJson(json['size'] as Map<String, dynamic>),
  orderItemStatus: $enumDecode(
    _$OrderItemStatusEnumMap,
    json['orderItemStatus'],
  ),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'menuItemId': instance.menuItemId,
  'item': instance.item.toJson(),
  'addOns': _addOnsToJson(instance.addOns),
  'menuItemPrice': instance.menuItemPrice,
  'size': instance.size.toJson(),
  'quantity': instance.quantity,
  'note': instance.note,
  'orderItemStatus': _$OrderItemStatusEnumMap[instance.orderItemStatus]!,
};

const _$OrderItemStatusEnumMap = {
  OrderItemStatus.pending: 'pending',
  OrderItemStatus.accepted: 'accepted',
  OrderItemStatus.rejected: 'rejected',
  OrderItemStatus.cancelled: 'cancelled',
};
