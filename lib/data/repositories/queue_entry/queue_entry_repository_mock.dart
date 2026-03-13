import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/data/repositories/order/order_repository_mock.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository_mock.dart';
import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:uuid/uuid.dart';

class QueueEntryRepositoryMock implements QueueEntryRepository {
  Map<String, QueueEntry> queueEntries = {};

  QueueEntryRepositoryMock() {
    for (QueueEntry queueEntry in mockQueueEntries) {
      queueEntries[queueEntry.id] = queueEntry;
    }
  }

  @override
  Future<void> create(QueueEntry queueEntry) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(QueueEntry queueEntry) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByCustomerId(
    String customerId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getByCustomerId
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getByRestaurantId
    throw UnimplementedError();
  }

  @override
  Future<QueueEntry?> getCurrentByCustomerId(String customerId) {
    // TODO: implement getCurrentByCustomerId
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getCurrentByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getCurrentByRestaurantId
    throw UnimplementedError();
  }

  @override
  Future<QueueEntry?> getQueueEntryById(String queueId) async {
    return queueEntries[queueId];
  }

  @override
  Future<QueueEntry> update(QueueEntry queueEntry) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<QueueEntry>> watchAllHistory() {
    // TODO: implement watchAllHistory
    throw UnimplementedError();
  }

  @override
  Stream<QueueEntry?> watchCurrentHistory() {
    // TODO: implement watchCurrentHistory
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getQueueHistory(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getTodayHistory
    throw UnimplementedError();
  }

  @override
  Stream<List<QueueEntry>> watchCurrentActiveQueue(String restId) {
    // TODO: implement watchCurrentActiveQueue
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(String queueId, QueueStatus newStatus) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }
}

List<QueueEntry> mockQueueEntries = [
  QueueEntry(
    restId: mockRestaurants[0].id,
    id: Uuid().v4(),
    queueNumber: 'A001',
    customerId: mockCustomers[0].id,
    partySize: 2,
    joinTime: DateTime.now().subtract(Duration(minutes: 5)),
    status: QueueStatus.waiting,
    joinedMethod: JoinedMethod.walkIn,
    orderId: mockOrders[0].id,
    tableNumber: 'T1',
    expectedTableReadyAt: DateTime.now(),
    assignedTableId: '',
  ),
  QueueEntry(
    restId: mockRestaurants[0].id,
    id: Uuid().v4(),
    queueNumber: 'A002',
    customerId: mockCustomers[1].id,
    partySize: 3,
    joinTime: DateTime.now().subtract(Duration(minutes: 8)),
    status: QueueStatus.waiting,
    joinedMethod: JoinedMethod.remote,
    orderId: mockOrders[1].id,
    tableNumber: 'T5',
    expectedTableReadyAt: DateTime.now(),
    assignedTableId: '',
  ),
  QueueEntry(
    restId: mockRestaurants[0].id,
    id: Uuid().v4(),
    queueNumber: 'A003',
    customerId: mockCustomers[3].id,
    partySize: 1,
    joinTime: DateTime.now().subtract(Duration(minutes: 2)),
    status: QueueStatus.waiting,
    joinedMethod: JoinedMethod.walkIn,
    orderId: "",
    tableNumber: 'T3',
    expectedTableReadyAt: DateTime.now(),
    assignedTableId: '',
  ),
];
