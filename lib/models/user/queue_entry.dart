import 'package:queue_station_app/models/restaurant/restaurant.dart';

import '../order/order.dart';

enum QueueStatus { waiting, serving, completed, cancelled, noShow }

enum JoinedMethod { remote, walkIn }

class QueueEntry {
  final String id;
  final String queueNumber;
  final String customerId;
  final int partySize;
  final DateTime joinTime;
  final DateTime? servedTime;
  final DateTime? endedTime;
  final QueueStatus status;
  final Order? order;
  final JoinedMethod joinedMethod;

  int currentSpot(Restaurant rest) {
    return rest.getQueueSpot(this);
  }

  QueueEntry({
    required this.id,
    required this.queueNumber,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    this.endedTime,
    required this.status,
    required this.customerId,
    this.order,
    required this.joinedMethod,
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
}
