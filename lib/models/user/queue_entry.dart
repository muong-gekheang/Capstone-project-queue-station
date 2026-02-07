import 'package:queue_station_app/models/restaurant/restaurant.dart';

import '../order/order.dart';

enum QueueStatus { waiting, serving, completed, cancelled, noShow }

class QueueEntry {
  final String id;
  final String customerId;
  final int partySize;
  final DateTime joinTime;
  final DateTime? servedTime;
  final QueueStatus status;
  final Order? order;

  int currentSpot(Restaurant rest) {
    return rest.getQueueSpot(this);
  }

  QueueEntry({
    required this.id,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    required this.status,
    required this.customerId,
    this.order,
  });

  @override
  bool operator ==(Object other) {
    return (other is QueueEntry &&
        (other.id == id) &&
        (other.customerId == customerId));
  }

  @override
  int get hashCode => Object.hash(id, customerId);
}
