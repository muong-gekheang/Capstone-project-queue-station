// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueTable _$QueueTableFromJson(Map<String, dynamic> json) => QueueTable(
  id: json['id'] as String?,
  tableNum: json['tableNum'] as String,
  tableStatus: $enumDecode(_$TableStatusEnumMap, json['tableStatus']),
  tableCategoryId: json['tableCategoryId'] as String?,
  queueEntryIds:
      (json['queueEntryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$QueueTableToJson(QueueTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableNum': instance.tableNum,
      'tableStatus': _$TableStatusEnumMap[instance.tableStatus]!,
      'tableCategoryId': instance.tableCategoryId,
      'queueEntryIds': instance.queueEntryIds,
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
};
