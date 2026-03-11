import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository_mock.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';

class QueueTableRepositoryMock implements QueueTableRepository {
  Map<String, QueueTable> queueTables = {};

  QueueTableRepositoryMock() {
    for (var queueTable in mockTables) {
      queueTables[queueTable.id] = queueTable;
    }
  }
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
  Stream<List<QueueTable>> watchAllQueueTable() {
    // TODO: implement watchAllQueueTable
    throw UnimplementedError();
  }

  @override
  Stream<QueueTable> watchCurrentQueueTable() {
    // TODO: implement watchCurrentQueueTable
    throw UnimplementedError();
  }
}

List<QueueTable> mockTables = [
  // Type A Tables
  QueueTable(
    tableNum: "A1",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A2",
    tableStatus: TableStatus.occupied,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A3",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A4",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A5",
    tableStatus: TableStatus.occupied,
    tableCategoryId: mockTableCategories[1].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A6",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[2].id,
    queueEntryIds: [],
  ),

  // Type B Tables
  QueueTable(
    tableNum: "B1",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[1].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B2",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B3",
    tableStatus: TableStatus.occupied,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B4",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),

  // Type C Tables
  QueueTable(
    tableNum: "T1",
    tableStatus: TableStatus.occupied,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "T2",
    tableStatus: TableStatus.occupied,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "T3",
    tableStatus: TableStatus.available,
    tableCategoryId: mockTableCategories[0].id,
    queueEntryIds: [],
  ),
];
