// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  ordered: (json['ordered'] as List<dynamic>?)
      ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  inCart: (json['inCart'] as List<dynamic>?)
      ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'ordered': instance.ordered.map((e) => e.toJson()).toList(),
  'inCart': instance.inCart.map((e) => e.toJson()).toList(),
  'timestamp': instance.timestamp.toIso8601String(),
};
