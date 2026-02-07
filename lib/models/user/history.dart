import '../restaurant/restaurant.dart';
import 'queue_entry.dart';

class History {
  final String id;
  final Restaurant rest;
  final QueueEntry queue;
  final String userId;

  const History({
    required this.rest,
    required this.queue,
    required this.id,
    required this.userId,
  });
}
