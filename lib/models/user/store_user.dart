import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

part 'store_user.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreUser extends User {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String userType = 'store';

  final String restaurantId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Restaurant? rest;

  StoreUser({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    String? restaurantId,
    this.rest,
  }) : restaurantId = restaurantId ?? rest?.id ?? '';

  StoreUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? id,
    String? restaurantId,
    Restaurant? rest,
  }) {
    return StoreUser(
      // Pass base class fields
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      id: id ?? this.id,
      // Pass subclass fields
      restaurantId: restaurantId ?? this.restaurantId,
      rest: rest ?? this.rest,
    );
  }

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}
