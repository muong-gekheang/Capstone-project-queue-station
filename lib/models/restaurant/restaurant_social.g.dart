// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialAccount _$SocialAccountFromJson(Map<String, dynamic> json) =>
    SocialAccount(
      id: json['id'] as String?,
      platform: json['platform'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );

Map<String, dynamic> _$SocialAccountToJson(SocialAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'username': instance.username,
    };
