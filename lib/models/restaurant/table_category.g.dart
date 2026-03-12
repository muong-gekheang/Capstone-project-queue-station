// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableCategory _$TableCategoryFromJson(Map<String, dynamic> json) =>
    TableCategory(
      type: json['type'] as String,
      minSeat: (json['minSeat'] as num).toInt(),
      seatAmount: (json['seatAmount'] as num).toInt(), id: '',
    );

Map<String, dynamic> _$TableCategoryToJson(TableCategory instance) =>
    <String, dynamic>{
      'type': instance.type,
      'minSeat': instance.minSeat,
      'seatAmount': instance.seatAmount,
    };
