// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  id: json['id'] as String,
  historyIds: (json['historyIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  currentHistoryId: json['currentHistoryId'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'userType': instance.userType,
  'historyIds': instance.historyIds,
  'currentHistoryId': instance.currentHistoryId,
};
