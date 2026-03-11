import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

abstract class QueueEntryRepository {
  Future<QueueEntry?> getQueueEntryById(String queueId);
  Future<QueueEntry?> getCurrentByCustomerId(String customerId);
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getCurrentByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByCustomerId(
    String customerId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> create(QueueEntry queueEntry);
  Future<void> delete(QueueEntry queueEntry);
  Future<QueueEntry> update(QueueEntry queueEntry);
  Stream<QueueEntry?> watchCurrentHistory();
  Stream<List<QueueEntry>> watchAllHistory();
}
