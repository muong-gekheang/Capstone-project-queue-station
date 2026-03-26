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
  menuSizeOptionIds:
      (json['sizeOptionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  addOnIds:
      (json['addOnIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  isAvailable: json['isAvailable'] as bool? ?? true,
  restaurantId: json['restaurantId'] as String,
  minPrice: (json['minPrice'] as num).toDouble(), categoryId: '${json['categoryId'] as String}',
);

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'minPrice': instance.minPrice,
  'description': instance.description,
  'minPrepTimeMinutes': instance.minPrepTimeMinutes,
  'maxPrepTimeMinutes': instance.maxPrepTimeMinutes,
  'categoryId': instance.categoryId,
  'restaurantId': instance.restaurantId,
  'menuSizeOptionIds': instance.menuSizeOptionIds,
  'addOnIds': instance.addOnIds,
  'isAvailable': instance.isAvailable,
};
