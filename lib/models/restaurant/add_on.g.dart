// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_on.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOn _$AddOnFromJson(Map<String, dynamic> json) => AddOn(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  image: json['image'] as String?,
);

Map<String, dynamic> _$AddOnToJson(AddOn instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'image': instance.image,
};
