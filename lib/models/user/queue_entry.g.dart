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
  orderId: json['orderId'] as String?,
  joinedMethod:
      $enumDecodeNullable(_$JoinedMethodEnumMap, json['joinedMethod']) ??
      JoinedMethod.remote,
  tableNumber: json['tableNumber'] as String?,
  restId: json['restId'] as String,
  customerName: json['customerName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  expectedTableReadyAt: DateTime.parse(json['expectedTableReadyAt'] as String),
  assignedTableId: json['assignedTableId'] as String,
);

Map<String, dynamic> _$QueueEntryToJson(QueueEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'queueNumber': instance.queueNumber,
      'restId': instance.restId,
      'customerId': instance.customerId,
      'assignedTableId': instance.assignedTableId,
      'partySize': instance.partySize,
      'joinTime': instance.joinTime.toIso8601String(),
      'expectedTableReadyAt': instance.expectedTableReadyAt.toIso8601String(),
      'servedTime': instance.servedTime?.toIso8601String(),
      'endedTime': instance.endedTime?.toIso8601String(),
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
