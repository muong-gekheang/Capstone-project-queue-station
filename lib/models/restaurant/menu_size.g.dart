// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuSize _$MenuSizeFromJson(Map<String, dynamic> json) => MenuSize(
  price: (json['price'] as num).toDouble(),
  sizeOption: SizeOption.fromJson(json['sizeOption'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MenuSizeToJson(MenuSize instance) => <String, dynamic>{
  'price': instance.price,
  'sizeOption': instance.sizeOption.toJson(),
};
