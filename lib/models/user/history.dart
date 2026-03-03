import 'package:json_annotation/json_annotation.dart';
import '../restaurant/restaurant.dart';
import 'queue_entry.dart';

part 'history.g.dart';

@JsonSerializable(explicitToJson: true)
class History {
  final String id;
  final Restaurant rest;
  final QueueEntry queue;
  final String userId;

  History({
    required this.rest,
    required this.queue,
    required this.userId,
    required this.id,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
