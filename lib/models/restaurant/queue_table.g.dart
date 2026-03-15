// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueTable _$QueueTableFromJson(Map<String, dynamic> json) => QueueTable(
  id: json['id'] as String?,
  tableNum: json['tableNum'] as String,
  restaurantId: json['restaurantId'] as String,
  tableStatus: $enumDecode(_$TableStatusEnumMap, json['tableStatus']),
  tableCategoryId: json['tableCategoryId'] as String,
  queueEntryIds:
      (json['queueEntryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  latestEstimatedReadyAt: json['latestEstimatedReadyAt'] == null
      ? null
      : DateTime.parse(json['latestEstimatedReadyAt'] as String),
);

Map<String, dynamic> _$QueueTableToJson(
  QueueTable instance,
) => <String, dynamic>{
  'id': instance.id,
  'tableNum': instance.tableNum,
  'restaurantId': instance.restaurantId,
  'tableCategoryId': instance.tableCategoryId,
  'tableStatus': _$TableStatusEnumMap[instance.tableStatus]!,
  'queueEntryIds': instance.queueEntryIds,
  'latestEstimatedReadyAt': instance.latestEstimatedReadyAt?.toIso8601String(),
};

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
};
