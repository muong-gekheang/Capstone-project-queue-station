import '../restaurant/restaurant.dart';
import 'queue_entry.dart';

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
}
