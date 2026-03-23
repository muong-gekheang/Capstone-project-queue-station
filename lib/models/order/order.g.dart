// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  timestamp: const TimestampConverter().fromJson(json['timestamp']),
  restaurantId: json['restaurantId'] as String,
  orderedIds:
      (json['orderedIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  inCartIds:
      (json['inCartIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'restaurantId': instance.restaurantId,
  'orderedIds': instance.orderedIds,
  'inCartIds': instance.inCartIds,
  'timestamp': const TimestampConverter().toJson(instance.timestamp),
};
