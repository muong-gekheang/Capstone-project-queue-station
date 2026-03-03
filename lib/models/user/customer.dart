import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/user/history.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends User {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String userType = 'customer';
  final List<History> histories;
  final History? currentHistory;

  Customer({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    required this.histories,
    this.currentHistory,
  });

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? id,
    List<History>? histories,
    History? currentHistory,
    bool? noQueue,
  }) {
    return Customer(
      name: name ?? super.name,
      email: email ?? super.email,
      phone: phone ?? super.phone,
      id: id ?? super.id,
      histories: histories ?? this.histories,
      currentHistory: (noQueue ?? false)
          ? null
          : currentHistory ?? this.currentHistory,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
