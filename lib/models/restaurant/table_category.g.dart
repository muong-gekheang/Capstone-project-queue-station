// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableCategory _$TableCategoryFromJson(Map<String, dynamic> json) =>
    TableCategory(
      id: json['id'] as String?,
      type: json['type'] as String,
      minSeat: (json['minSeat'] as num).toInt(),
      seatAmount: (json['seatAmount'] as num).toInt(),
      restaurantId: json['restaurantId'] as String,
    );

Map<String, dynamic> _$TableCategoryToJson(TableCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'restaurantId': instance.restaurantId,
      'minSeat': instance.minSeat,
      'seatAmount': instance.seatAmount,
    };
