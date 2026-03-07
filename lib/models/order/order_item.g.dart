// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  menuItemId: json['menuItemId'] as String,
  menuItemPrice: (json['menuItemPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  note: json['note'] as String?,
  orderItemStatus: $enumDecode(
    _$OrderItemStatusEnumMap,
    json['orderItemStatus'],
  ),
  addOns: _addOnsFromJson(json['addOns'] as Map<String, dynamic>),
  sizeName: json['sizeName'] as String?,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'menuItemId': instance.menuItemId,
  'addOns': _addOnsToJson(instance.addOns),
  'menuItemPrice': instance.menuItemPrice,
  'sizeName': instance.sizeName,
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
