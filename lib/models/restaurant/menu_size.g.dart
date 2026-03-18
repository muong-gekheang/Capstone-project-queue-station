// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuSize _$MenuSizeFromJson(Map<String, dynamic> json) => MenuSize(
  price: (json['price'] as num).toDouble(),
  id: json['id'] as String,
  sizeOptionId: json['sizeOptionId'] as String,
);

Map<String, dynamic> _$MenuSizeToJson(MenuSize instance) => <String, dynamic>{
  'id': instance.id,
  'sizeOptionId': instance.sizeOptionId,
  'price': instance.price,
};
