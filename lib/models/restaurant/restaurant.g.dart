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
  isOpen: json['isOpen'] as bool? ?? true,
  email: json['email'] as String? ?? '',
  subscriptionDate: json['subscriptionDate'] == null
      ? DateTime.now()
      : const TimestampConverter().fromJson(json['subscriptionDate']),
  subscriptionStatus:
      $enumDecodeNullable(
        _$SubscriptionStatusEnumMap,
        json['subscriptionStatus'],
      ) ??
      SubscriptionStatus.paid,
  openingTime: (json['openingTime'] as num?)?.toInt() ?? 0,
  closingTime: (json['closingTime'] as num?)?.toInt() ?? 0,
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
      'isOpen': instance.isOpen,
      'email': instance.email,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'subscriptionDate': const TimestampConverter().toJson(
        instance.subscriptionDate,
      ),
      'subscriptionStatus':
          _$SubscriptionStatusEnumMap[instance.subscriptionStatus]!,
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.paid: 'paid',
  SubscriptionStatus.expired: 'expired',
};
