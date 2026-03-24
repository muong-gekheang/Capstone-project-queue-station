import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/utils/timestamp_converter.dart';
import 'menu_item.dart';
import 'queue_table.dart';

part 'restaurant.g.dart';

enum SubscriptionStatus { active, expired }

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String address;
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
  @JsonKey(defaultValue: 0)
  final int openingTime; // this need to be store in minute to handle the time like 8:30 which is equal to 510
  @JsonKey(defaultValue: 0)
  final int closingTime;
  @JsonKey(defaultValue: DateTime.now)
  @TimestampConverter()
  final DateTime subscriptionDate;
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
    this.subscriptionStatus = SubscriptionStatus.active,
    required this.openingTime,
    required this.closingTime,
  }) : itemIds = itemIds ?? [],
       tableIds = tableIds ?? [],
       globalAddOnIds = globalAddOnIds ?? [],
       globalSizeOptionIds = globalSizeOptionIds ?? [];

  Duration get averageWaitingTime => const Duration(hours: 1);

  bool get isCurrentlyOpen {
    if (!isOpen) return false;

    final now = DateTime.now();
    // convert hour to minute
    final currentTimeInMinute = now.hour * 60 + now.minute;

    if (openingTime < closingTime) {
      return currentTimeInMinute >= openingTime &&
          currentTimeInMinute <= closingTime;
    } else {
      // this is to handle restaurant with this opening time : 18:00 (6PM) - 2AM
      return currentTimeInMinute <= openingTime ||
          currentTimeInMinute >= closingTime;
    }
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? address,
    String? logoLink,
    String? policy,
    int? biggestTableSize,
    String? phone,
    List<String>? itemIds,
    List<String>? tableIds,
    List<String>? globalAddOnIds,
    List<String>? globalSizeOptionIds,
    bool? isOpen,
    String? email,
    DateTime? subscriptionDate,
    SubscriptionStatus? subscriptionStatus,
    int? openingTime,
    int? closingTime,
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
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
