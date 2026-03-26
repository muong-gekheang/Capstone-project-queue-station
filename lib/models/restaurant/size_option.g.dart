// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeOption _$SizeOptionFromJson(Map<String, dynamic> json) => SizeOption(
  name: json['name'] as String,
  id: json['id'] as String,
  restaurantId: json['restaurantId'] as String,
);

Map<String, dynamic> _$SizeOptionToJson(SizeOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'restaurantId': instance.restaurantId,
    };
