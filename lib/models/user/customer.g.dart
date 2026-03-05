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
  histories: (json['histories'] as List<dynamic>)
      .map((e) => QueueEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentHistory: json['currentHistory'] == null
      ? null
      : QueueEntry.fromJson(json['currentHistory'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'userType': instance.userType,
  'histories': instance.histories.map((e) => e.toJson()).toList(),
  'currentHistory': instance.currentHistory?.toJson(),
};
