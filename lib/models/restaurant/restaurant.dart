import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/restaurant_social.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:queue_station_app/utils/latlng_converter.dart';
import 'package:queue_station_app/utils/timestamp_converter.dart';

import 'package:uuid/uuid.dart';

part 'restaurant.g.dart';

final uuid = Uuid();

enum SubscriptionStatus {
  @JsonValue('paid')
  paid,
  @JsonValue('expired')
  expired,
  @JsonValue('active')
  active,
}

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
  @JsonKey(defaultValue: <String>[])
  @JsonKey(
    defaultValue: SubscriptionStatus.paid,
    unknownEnumValue: SubscriptionStatus.expired,
  )
  final List<String> currentInQueueIds;

  final bool isOpen;
  final String email;
  @JsonKey(defaultValue: 0)
  final int openingTime; // this need to be store in minute to handle the time like 8:30 which is equal to 510
  @JsonKey(defaultValue: 0)
  final int closingTime;
  @TimestampConverter()
  final DateTime subscriptionDate;
  final SubscriptionStatus subscriptionStatus;

  @LatLngConverter()
  LatLng? location;
  @JsonKey(defaultValue: <String>[])
  List<String> menuImageLinks;
  @JsonKey(defaultValue: <String>[])
  List<String>? contactDetailIds;

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
    List<String>? currentInQueueIds,
    this.isOpen = true,
    this.email = '',
    required this.subscriptionDate,
    this.subscriptionStatus = SubscriptionStatus.paid,
    required this.openingTime,
    required this.closingTime,
    this.location,
    List<String>? contactDetailIds,
    List<String>? menuImageLinks,
  }) : itemIds = itemIds ?? [],
       tableIds = tableIds ?? [],
       globalAddOnIds = globalAddOnIds ?? [],
       globalSizeOptionIds = globalSizeOptionIds ?? [],
       currentInQueueIds = currentInQueueIds ?? [],
       contactDetailIds = contactDetailIds ?? [],
       menuImageLinks = menuImageLinks ?? [];

  Duration get averageWaitingTime => const Duration(hours: 1);

  int get curWait => currentInQueueIds.length;

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
    List<String>? currentInQueueIds,
    bool? isOpen,
    String? email,
    DateTime? subscriptionDate,
    SubscriptionStatus? subscriptionStatus,
    int? openingTime,
    int? closingTime,
    LatLng? location,
    List<String>? menuImageLinks,
    List<String>? contactDetailIds,
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
      currentInQueueIds: currentInQueueIds ?? this.currentInQueueIds,
      isOpen: isOpen ?? this.isOpen,
      email: email ?? this.email,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      location: location ?? this.location,
      menuImageLinks: menuImageLinks ?? this.menuImageLinks,
      contactDetailIds: contactDetailIds ?? this.contactDetailIds,
    );
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
