import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'restaurant_social.g.dart';

final uuid = Uuid();

@JsonSerializable()
class SocialAccount {
  final String id;
  @JsonKey(defaultValue: '')
  final String? platform;
  @JsonKey(defaultValue: '')
  final String? username;

  SocialAccount({String? id, String? platform, String? username})
    : id = id ?? uuid.v4(),
      platform = platform ?? "",
      username = username ?? "";

  factory SocialAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountFromJson(json);

  Map<String, dynamic> toJson() => _$SocialAccountToJson(this);
}
