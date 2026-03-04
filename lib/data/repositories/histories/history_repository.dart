import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/user/history.dart';

abstract class HistoryRepository {
  Future<History?> getHistoryById(String historyId);
  Future<History?> getCurrentHistoryByUserId(String userId);
  Future<(List<History>, DocumentSnapshot<Map<String, dynamic>>?)> getAllHistoriesByRestaurantId(String restaurantId, int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc);
  Future<(List<History>, DocumentSnapshot<Map<String, dynamic>>?)> getAllHistoriesByUserId(String userId, int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> create(History history);
  Future<void> delete(History history);
  Future<History> update(History history);
  Stream<History?> watchCurrentHistory();
}
