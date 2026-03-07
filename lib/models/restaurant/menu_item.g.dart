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
  categoryId: json['categoryId'] as String?,
  sizeOptionIds:
      (json['sizeOptionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  addOnIds:
      (json['addOnIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'description': instance.description,
  'minPrepTimeMinutes': instance.minPrepTimeMinutes,
  'maxPrepTimeMinutes': instance.maxPrepTimeMinutes,
  'categoryId': instance.categoryId,
  'sizeOptionIds': instance.sizeOptionIds,
  'addOnIds': instance.addOnIds,
  'isAvailable': instance.isAvailable,
};
