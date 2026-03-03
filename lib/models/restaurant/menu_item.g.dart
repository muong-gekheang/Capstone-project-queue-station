// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
  id: json['id'] as String,
  image: json['image'] as String?,
  name: json['name'] as String,
  description: json['description'] as String,
  minPrepTimeMinutes: (json['minPrepTimeMinutes'] as num?)?.toInt(),
  maxPrepTimeMinutes: (json['maxPrepTimeMinutes'] as num?)?.toInt(),
  category: MenuItemCategory.fromJson(json['category'] as Map<String, dynamic>),
  sizes: (json['sizes'] as List<dynamic>?)
      ?.map((e) => MenuSize.fromJson(e as Map<String, dynamic>))
      .toList(),
  addOns: (json['addOns'] as List<dynamic>?)
      ?.map((e) => AddOn.fromJson(e as Map<String, dynamic>))
      .toList(),
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'description': instance.description,
  'minPrepTimeMinutes': instance.minPrepTimeMinutes,
  'maxPrepTimeMinutes': instance.maxPrepTimeMinutes,
  'category': instance.category.toJson(),
  'sizes': instance.sizes.map((e) => e.toJson()).toList(),
  'addOns': instance.addOns.map((e) => e.toJson()).toList(),
  'isAvailable': instance.isAvailable,
};
