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
  policy: json['policy'] as String? ?? "",
  biggestTableSize: (json['biggestTableSize'] as num).toInt(),
  phone: json['phone'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  tables: (json['tables'] as List<dynamic>)
      .map((e) => QueueTable.fromJson(e as Map<String, dynamic>))
      .toList(),
  globalAddOns: (json['globalAddOns'] as List<dynamic>)
      .map((e) => AddOn.fromJson(e as Map<String, dynamic>))
      .toList(),
  globalSizeOptions: (json['globalSizeOptions'] as List<dynamic>)
      .map((e) => SizeOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentInQueue: (json['currentInQueue'] as List<dynamic>?)
      ?.map((e) => QueueEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
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
      'items': instance.items.map((e) => e.toJson()).toList(),
      'tables': instance.tables.map((e) => e.toJson()).toList(),
      'globalAddOns': instance.globalAddOns.map((e) => e.toJson()).toList(),
      'globalSizeOptions': instance.globalSizeOptions
          .map((e) => e.toJson())
          .toList(),
      'currentInQueue': instance.currentInQueue.map((e) => e.toJson()).toList(),
    };
