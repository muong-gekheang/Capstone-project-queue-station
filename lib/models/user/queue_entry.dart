import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

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
  final DateTime expectedTableReadyAt;
  final DateTime? servedTime;
  final DateTime? endedTime;
  final QueueStatus status;
  final String? orderId;
  final JoinedMethod joinedMethod;
  final String? tableNumber;
  final String? customerName; // Only store when the joinedMethod is walkIn
  final String? phoneNumber; // Only store when the joinedMethod is walkIn

  int currentSpot(Restaurant rest) {
    return rest.getQueueSpot(this);
  }

  const QueueEntry({
    required this.id,
    required this.queueNumber,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    this.endedTime,
    required this.status,
    required this.customerId,
    this.orderId,
    this.joinedMethod = JoinedMethod.remote,
    this.tableNumber,
    required this.restId,
    this.customerName,
    this.phoneNumber,
    required this.expectedTableReadyAt, // Added to constructor
  });

  const QueueEntry.walkIn({
  const QueueEntry({
    required this.id,
    required this.queueNumber,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    this.endedTime,
    required this.status,
    required this.customerId,
    this.orderId,
    this.joinedMethod = JoinedMethod.remote,
    this.tableNumber,
    required this.restId,
    this.customerName,
    this.phoneNumber,
    required this.expectedTableReadyAt, // Added to constructor
  });

  const QueueEntry.walkIn({
    required this.id,
    required this.queueNumber,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    this.endedTime,
    required this.status,
    required this.customerId,
    this.orderId,
    this.joinedMethod = JoinedMethod.walkIn,
    this.orderId,
    this.joinedMethod = JoinedMethod.walkIn,
    this.tableNumber,
    required this.restId,
    required this.customerName,
    required this.phoneNumber,
    required this.expectedTableReadyAt,
  });
    required this.customerName,
    required this.phoneNumber,
    required this.expectedTableReadyAt,
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

  /// Use for Remote Users (App Account)
  QueueEntry remoteCopyWith({
    String? queueNumber,
    int? partySize,
    DateTime? servedTime,
    DateTime? endedTime,
    QueueStatus? status,
    QueueStatus? status,
    Order? order,
    String? orderId,
    JoinedMethod? joinedMethod,
    String? tableNumber,
    DateTime? expectedTableReadyAt,
  }) {
    return QueueEntry(
      id: id,
      restId: restId,
      customerId: customerId, // Original User ID
      joinTime: joinTime,
      joinedMethod: JoinedMethod.remote,
      queueNumber: queueNumber ?? this.queueNumber,
      partySize: partySize ?? this.partySize,
      servedTime: servedTime ?? this.servedTime,
      endedTime: endedTime ?? this.endedTime,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      tableNumber: tableNumber ?? this.tableNumber,
      // Keep existing (likely null)
      customerName: customerName,
      phoneNumber: phoneNumber,
      expectedTableReadyAt: expectedTableReadyAt ?? this.expectedTableReadyAt,
    );
  }

  /// Use for Walk-In Users (Created by the Store)
  QueueEntry walkInCopyWith({
    String? queueNumber,
    int? partySize,
    DateTime? servedTime,
    DateTime? endedTime,
    QueueStatus? status,
    String? orderId,
    String? tableNumber,
    String? customerName,
    String? phoneNumber,
    DateTime? expectedTableReadyAt,
  }) {
    return QueueEntry.walkIn(
      id: id,
      restId: restId,
      customerId: customerId, // This will be the storeId
      joinTime: joinTime,
      // joinedMethod is hardcoded to .walkIn in the constructor
      queueNumber: queueNumber ?? this.queueNumber,
      partySize: partySize ?? this.partySize,
      servedTime: servedTime ?? this.servedTime,
      endedTime: endedTime ?? this.endedTime,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      tableNumber: tableNumber ?? this.tableNumber,
      // Use ! because the .walkIn constructor requires these to be non-null
      customerName: customerName ?? this.customerName!,
      phoneNumber: phoneNumber ?? this.phoneNumber!,
      expectedTableReadyAt: expectedTableReadyAt ?? this.expectedTableReadyAt,
    );
  }

  factory QueueEntry.fromJson(Map<String, dynamic> json) =>
      _$QueueEntryFromJson(json);

  Map<String, dynamic> toJson() => _$QueueEntryToJson(this);
}
