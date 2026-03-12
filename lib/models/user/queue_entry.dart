import 'package:json_annotation/json_annotation.dart';

import '../order/order.dart';

part 'queue_entry.g.dart';

enum QueueStatus { waiting, serving, completed, cancelled, noShow }

enum JoinedMethod { remote, walkIn }

@JsonSerializable(explicitToJson: true)
class QueueEntry {
  final String id;
  final String queueNumber;
  final String restId;
  final String customerId;
  final int partySize;
  final DateTime joinTime;
  final DateTime? servedTime;
  final DateTime? endedTime;
  final QueueStatus status;
  final String? orderId;
  final JoinedMethod joinedMethod;
  final String? tableNumber;
  final DateTime? expectedTableReadyAt;

  QueueEntry({
    required this.id,
    required this.queueNumber,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    this.endedTime,
    required this.status,
    required this.customerId,
    this.orderId,
    required this.joinedMethod,
    this.tableNumber,
    this.expectedTableReadyAt,
    required this.restId,
  });

  Duration? get waitingTime {
    if (servedTime == null) return null;
    return servedTime!.difference(joinTime);
  }

  String get waitingTimeText {
    final duration = waitingTime;
    if (duration == null) return 'Unavailable';

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');

    return '$mm:$ss min';
  }

  @override
  bool operator ==(Object other) {
    return (other is QueueEntry &&
        (other.id == id) &&
        (other.customerId == customerId));
  }

  @override
  int get hashCode => Object.hash(id, customerId);

  QueueEntry copyWith({
    String? id,
    String? queueNumber,
    String? customerId,
    String? restId,
    int? partySize,
    DateTime? joinTime,
    DateTime? servedTime,
    DateTime? endedTime,
    QueueStatus? status,
    Order? order,
    String? orderId,
    JoinedMethod? joinedMethod,
    String? tableNumber,
  }) {
    return QueueEntry(
      id: id ?? this.id,
      queueNumber: queueNumber ?? this.queueNumber,
      customerId: customerId ?? this.customerId,
      partySize: partySize ?? this.partySize,
      joinTime: joinTime ?? this.joinTime,
      servedTime: servedTime ?? this.servedTime,
      endedTime: endedTime ?? this.endedTime,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      joinedMethod: joinedMethod ?? this.joinedMethod,
      tableNumber: tableNumber ?? this.tableNumber,
      restId: restId ?? this.restId,
    );
  }

  factory QueueEntry.fromJson(Map<String, dynamic> json) =>
      _$QueueEntryFromJson(json);

  Map<String, dynamic> toJson() => _$QueueEntryToJson(this);
}
