// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueEntry _$QueueEntryFromJson(Map<String, dynamic> json) => QueueEntry(
  id: json['id'] as String,
  queueNumber: json['queueNumber'] as String,
  partySize: (json['partySize'] as num).toInt(),
  joinTime: DateTime.parse(json['joinTime'] as String),
  servedTime: json['servedTime'] == null
      ? null
      : DateTime.parse(json['servedTime'] as String),
  endedTime: json['endedTime'] == null
      ? null
      : DateTime.parse(json['endedTime'] as String),
  status: $enumDecode(_$QueueStatusEnumMap, json['status']),
  customerId: json['customerId'] as String,
  order: json['order'] == null
      ? null
      : Order.fromJson(json['order'] as Map<String, dynamic>),
  joinedMethod: $enumDecode(_$JoinedMethodEnumMap, json['joinedMethod']),
  tableNumber: json['tableNumber'] as String?,
);

Map<String, dynamic> _$QueueEntryToJson(QueueEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'queueNumber': instance.queueNumber,
      'customerId': instance.customerId,
      'partySize': instance.partySize,
      'joinTime': instance.joinTime.toIso8601String(),
      'servedTime': instance.servedTime?.toIso8601String(),
      'endedTime': instance.endedTime?.toIso8601String(),
      'status': _$QueueStatusEnumMap[instance.status]!,
      'order': instance.order?.toJson(),
      'joinedMethod': _$JoinedMethodEnumMap[instance.joinedMethod]!,
      'tableNumber': instance.tableNumber,
    };

const _$QueueStatusEnumMap = {
  QueueStatus.waiting: 'waiting',
  QueueStatus.serving: 'serving',
  QueueStatus.completed: 'completed',
  QueueStatus.cancelled: 'cancelled',
  QueueStatus.noShow: 'noShow',
};

const _$JoinedMethodEnumMap = {
  JoinedMethod.remote: 'remote',
  JoinedMethod.walkIn: 'walkIn',
};
