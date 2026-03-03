// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueTable _$QueueTableFromJson(Map<String, dynamic> json) => QueueTable(
  id: json['id'] as String?,
  tableNum: json['tableNum'] as String,
  tableStatus: $enumDecode(_$TableStatusEnumMap, json['tableStatus']),
  tableCategory: TableCategory.fromJson(
    json['tableCategory'] as Map<String, dynamic>,
  ),
  customers: _usersFromJson(json['customers'] as List?),
  currentQueueEntryId: json['currentQueueEntryId'] as String?,
  occupiedSince: json['occupiedSince'] == null
      ? null
      : DateTime.parse(json['occupiedSince'] as String),
);

Map<String, dynamic> _$QueueTableToJson(QueueTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableNum': instance.tableNum,
      'tableStatus': _$TableStatusEnumMap[instance.tableStatus]!,
      'tableCategory': instance.tableCategory.toJson(),
      'customers': _usersToJson(instance.customers),
      'currentQueueEntryId': instance.currentQueueEntryId,
      'occupiedSince': instance.occupiedSince?.toIso8601String(),
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
};
