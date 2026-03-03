// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableCategory _$TableCategoryFromJson(Map<String, dynamic> json) =>
    TableCategory(
      type: json['type'] as String,
      seatAmount: (json['seatAmount'] as num).toInt(),
    );

Map<String, dynamic> _$TableCategoryToJson(TableCategory instance) =>
    <String, dynamic>{'type': instance.type, 'seatAmount': instance.seatAmount};
