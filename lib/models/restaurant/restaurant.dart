import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

import 'menu_item.dart';
import 'queue_table.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String? description;
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
  final List<String> currentInQueueIds;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<MenuItem> items;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<QueueTable> tables;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<AddOn> globalAddOns;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<SizeOption> globalSizeOptions;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<QueueEntry> currentInQueue;

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
    List<MenuItem>? items,
    List<QueueTable>? tables,
    List<AddOn>? globalAddOns,
    List<SizeOption>? globalSizeOptions,
    List<QueueEntry>? currentInQueue,
    this.description,
  }) : items = items ?? [],
       tables = tables ?? [],
       globalAddOns = globalAddOns ?? [],
       globalSizeOptions = globalSizeOptions ?? [],
       currentInQueue = currentInQueue ?? [],
       itemIds = itemIds ?? (items ?? []).map((e) => e.id).toList(),
       tableIds = tableIds ?? (tables ?? []).map((e) => e.id).toList(),
       globalAddOnIds =
           globalAddOnIds ?? (globalAddOns ?? []).map((e) => e.id).toList(),
       globalSizeOptionIds =
           globalSizeOptionIds ??
           (globalSizeOptions ?? []).map((e) => e.name).toList(),
       currentInQueueIds =
           currentInQueueIds ??
           (currentInQueue ?? []).map((e) => e.id).toList();

  void enqueue(QueueEntry queue) {
    if (!currentInQueueIds.contains(queue.id)) {
      currentInQueueIds.add(queue.id);
    }
    if (!currentInQueue.contains(queue)) {
      currentInQueue.add(queue);
    }
  }

  void dequeue(QueueEntry queue) {
    currentInQueueIds.remove(queue.id);
    currentInQueue.remove(queue);
  }

  int getQueueSpot(QueueEntry queue) {
    final idx = currentInQueueIds.indexOf(queue.id);
    if (idx != -1) return idx + 1;
    return currentInQueue.indexOf(queue) +
        1; // fallback for in-memory only flow
  }

  Duration get averageWaitingTime => const Duration(hours: 1);

  int get curWait => currentInQueueIds.length;

  @override
  bool operator ==(Object other) {
    return (other is Restaurant) &&
        (other.name == name &&
            other.id == id &&
            other.address == address &&
            other.phone == phone);
  }

  @override
  int get hashCode => Object.hash(name, address, phone);

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
