import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';

/// Mock list of queue tables used for legacy UI screens and testing.
final List<QueueTable> mockTables = [
  QueueTable(
    id: 'table-1',
    tableNum: 'T1',
    restaurantId: 'rest-1',
    tableCategoryId: 'cat-1',
    tableStatus: TableStatus.available,
    queueEntryIds: [],
  ),
  QueueTable(
    id: 'table-2',
    tableNum: 'T2',
    restaurantId: 'rest-1',
    tableCategoryId: 'cat-1',
    tableStatus: TableStatus.available,
    queueEntryIds: [],
  ),
  QueueTable(
    id: 'table-3',
    tableNum: 'T3',
    restaurantId: 'rest-1',
    tableCategoryId: 'cat-2',
    tableStatus: TableStatus.available,
    queueEntryIds: [],
  ),
];

class QueueTableRepositoryMock implements QueueTableRepository {
  Map<String, QueueTable> queueTables = {};

  QueueTableRepositoryMock();
  @override
  Future<void> create(QueueTable table) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String tableId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAllByRestaurantId
    throw UnimplementedError();
  }

  @override
  Future<QueueTable?> getQueueTableById(String tableId) {
    // TODO: implement getQueueTableById
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchQueueTables(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getSearchQueueTables
    throw UnimplementedError();
  }

  @override
  Future<QueueTable> update(QueueTable table) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<QueueTable>> watchAllQueueTable(String restId) {
    // TODO: implement watchAllQueueTable
    throw UnimplementedError();
  }

  @override
  Stream<QueueTable> watchCurrentQueueTable() {
    // TODO: implement watchCurrentQueueTable
    throw UnimplementedError();
  }

  @override
  Future<void> addCustomerToTable(QueueTable table, String queueEntryId) {
    // TODO: implement addCustomerToTable
    throw UnimplementedError();
  }
}
