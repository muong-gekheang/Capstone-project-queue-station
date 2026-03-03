import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

part 'store_user.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreUser extends User {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String userType = 'store';
  final Restaurant rest;
  StoreUser({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    required this.rest,
  });

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}
