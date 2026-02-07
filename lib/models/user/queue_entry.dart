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

  QueueEntry({
    required this.id,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    required this.status,
    required this.customerId,
    this.order,
  });
}
