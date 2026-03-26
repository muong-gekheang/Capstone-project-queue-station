// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemCategory _$MenuItemCategoryFromJson(Map<String, dynamic> json) =>
    MenuItemCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      imageLink: json['imageLink'] as String?,
    )..restaurantId = json['restaurantId'] as String?;

Map<String, dynamic> _$MenuItemCategoryToJson(MenuItemCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'restaurantId': instance.restaurantId,
      'imageLink': instance.imageLink,
    };
