import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

enum SubscriptionStatus { paid, expired }

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String address;
  final String? description;
  final String logoLink;
  final String policy;
  final int biggestTableSize;
  final String phone;

  @JsonKey(defaultValue: <String>[])
  final List<String> itemIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> tableIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> globalAddOnIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> globalSizeOptionIds;

  final bool isOpen;
  final String email;
  @JsonKey(defaultValue: '')
  final String subscriptionDate;
  final SubscriptionStatus subscriptionStatus;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.logoLink,
    this.policy = '',
    required this.biggestTableSize,
    required this.phone,
    List<String>? itemIds,
    List<String>? tableIds,
    List<String>? globalAddOnIds,
    List<String>? globalSizeOptionIds,
    this.isOpen = true,
    this.email = '',
    required this.subscriptionDate,
    this.subscriptionStatus = SubscriptionStatus.paid,
    this.description,
  }) : itemIds = itemIds ?? [],
       tableIds = tableIds ?? [],
       globalAddOnIds = globalAddOnIds ?? [],
       globalSizeOptionIds = globalSizeOptionIds ?? [];

  Duration get averageWaitingTime => const Duration(hours: 1);

  @override
  bool operator ==(Object other) {
    return (other is Restaurant) &&
        (other.name == name &&
            other.id == id &&
            other.address == address &&
            other.isOpen == isOpen &&
            other.phone == phone);
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? address,
    String? logoLink,
    String? description,
    String? policy,
    int? biggestTableSize,
    String? phone,
    List<String>? itemIds,
    List<String>? tableIds,
    List<String>? globalAddOnIds,
    List<String>? globalSizeOptionIds,
    bool? isOpen,
    String? email,
    String? subscriptionDate,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      logoLink: logoLink ?? this.logoLink,
      policy: policy ?? this.policy,
      biggestTableSize: biggestTableSize ?? this.biggestTableSize,
      phone: phone ?? this.phone,
      itemIds: itemIds ?? this.itemIds,
      tableIds: tableIds ?? this.tableIds,
      globalAddOnIds: globalAddOnIds ?? this.globalAddOnIds,
      globalSizeOptionIds: globalSizeOptionIds ?? this.globalSizeOptionIds,
      isOpen: isOpen ?? this.isOpen,
      email: email ?? this.email,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode => Object.hash(name, address, phone, isOpen);

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
