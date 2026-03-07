// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  logoLink: json['logoLink'] as String,
  policy: json['policy'] as String? ?? '',
  biggestTableSize: (json['biggestTableSize'] as num).toInt(),
  phone: json['phone'] as String,
  itemIds:
      (json['itemIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  tableIds:
      (json['tableIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  globalAddOnIds:
      (json['globalAddOnIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  globalSizeOptionIds:
      (json['globalSizeOptionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  currentInQueueIds:
      (json['currentInQueueIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'logoLink': instance.logoLink,
      'policy': instance.policy,
      'biggestTableSize': instance.biggestTableSize,
      'phone': instance.phone,
      'itemIds': instance.itemIds,
      'tableIds': instance.tableIds,
      'globalAddOnIds': instance.globalAddOnIds,
      'globalSizeOptionIds': instance.globalSizeOptionIds,
      'currentInQueueIds': instance.currentInQueueIds,
    };
