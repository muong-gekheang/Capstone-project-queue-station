import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends User {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String userType = 'customer';
  final List<String> historyIds;
  final String? currentHistoryId;

  Customer({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    required this.historyIds,
    this.currentHistoryId,
  });

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? id,
    List<String>? historyIds,
    String? currentHistoryId,
    bool? noQueue,
  }) {
    return Customer(
      name: name ?? super.name,
      email: email ?? super.email,
      phone: phone ?? super.phone,
      id: id ?? super.id,
      historyIds: historyIds ?? this.historyIds,
      currentHistoryId: (noQueue ?? false)
          ? null
          : currentHistoryId ?? this.currentHistoryId,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
