// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreUser _$StoreUserFromJson(Map<String, dynamic> json) => StoreUser(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  id: json['id'] as String,
  restaurantId: json['restaurantId'] as String?, 
);

Map<String, dynamic> _$StoreUserToJson(StoreUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'userType': instance.userType,
  'restaurantId': instance.restaurantId,
};
