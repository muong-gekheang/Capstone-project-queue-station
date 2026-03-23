// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueEntry _$QueueEntryFromJson(Map<String, dynamic> json) => QueueEntry(
  id: json['id'] as String,
  queueNumber: json['queueNumber'] as String,
  partySize: (json['partySize'] as num).toInt(),
  joinTime: const TimestampConverter().fromJson(json['joinTime']),
  servedTime: const NullableTimestampConverter().fromJson(json['servedTime']),
  endedTime: const NullableTimestampConverter().fromJson(json['endedTime']),
  status: $enumDecode(_$QueueStatusEnumMap, json['status']),
  customerId: json['customerId'] as String,
  orderId: json['orderId'] as String?,
  joinedMethod:
      $enumDecodeNullable(_$JoinedMethodEnumMap, json['joinedMethod']) ??
      JoinedMethod.remote,
  tableNumber: json['tableNumber'] as String?,
  restId: json['restId'] as String,
  customerName: json['customerName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  expectedTableReadyAt: const TimestampConverter().fromJson(
    json['expectedTableReadyAt'],
  ),
  assignedTableId: json['assignedTableId'] as String,
);

Map<String, dynamic> _$QueueEntryToJson(
  QueueEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'queueNumber': instance.queueNumber,
  'restId': instance.restId,
  'customerId': instance.customerId,
  'assignedTableId': instance.assignedTableId,
  'partySize': instance.partySize,
  'joinTime': const TimestampConverter().toJson(instance.joinTime),
  'expectedTableReadyAt': const TimestampConverter().toJson(
    instance.expectedTableReadyAt,
  ),
  'servedTime': const NullableTimestampConverter().toJson(instance.servedTime),
  'endedTime': const NullableTimestampConverter().toJson(instance.endedTime),
  'status': _$QueueStatusEnumMap[instance.status]!,
  'orderId': instance.orderId,
  'joinedMethod': _$JoinedMethodEnumMap[instance.joinedMethod]!,
  'tableNumber': instance.tableNumber,
  'customerName': instance.customerName,
  'phoneNumber': instance.phoneNumber,
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
