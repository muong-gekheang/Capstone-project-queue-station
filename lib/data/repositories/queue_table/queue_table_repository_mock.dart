import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';

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
