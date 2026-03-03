// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
  rest: Restaurant.fromJson(json['rest'] as Map<String, dynamic>),
  queue: QueueEntry.fromJson(json['queue'] as Map<String, dynamic>),
  userId: json['userId'] as String,
  id: json['id'] as String,
);

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
  'id': instance.id,
  'rest': instance.rest.toJson(),
  'queue': instance.queue.toJson(),
  'userId': instance.userId,
};
