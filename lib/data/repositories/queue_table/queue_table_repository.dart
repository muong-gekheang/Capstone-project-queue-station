import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';

abstract class QueueTableRepository {
  Future<void> create(QueueTable table);
  Future<void> delete(String tableId);
  Future<QueueTable> update(QueueTable table);
  Future<QueueTable?> getQueueTableById(String tableId);
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchQueueTables(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Stream<QueueTable> watchCurrentQueueTable();
  Stream<List<QueueTable>> watchAllQueueTable(String restId);
}
