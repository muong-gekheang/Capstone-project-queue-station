import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

abstract class HistoryRepository {
  Future<QueueEntry?> getHistoryById(String queueId);
  Future<QueueEntry?> getCurrentHistoryByUserId(String userId);
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllHistoriesByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllHistoriesByUserId(
    String userId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> create(QueueEntry history);
  Future<void> delete(QueueEntry history);
  Future<QueueEntry> update(QueueEntry history);
  Stream<QueueEntry?> watchCurrentHistory();
  Stream<List<QueueEntry>> watchAllHistory();
}
