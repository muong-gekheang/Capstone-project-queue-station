import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class TableCategoryRepositoryMock implements TableCategoryRepository {
  Map<String, TableCategory> tableCategories = {};

  TableCategoryRepositoryMock() {
    for (var tableCat in mockTableCategories) {
      tableCategories[tableCat.id] = tableCat;
    }
  }

  @override
  Future<void> create(TableCategory category) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String categoryId) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) {
    throw UnimplementedError();
  }

  @override
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<List<TableCategory>> getManyTableCategoriesById(List<String> ids) {
    throw UnimplementedError();
  }

  @override
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchCategories(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<TableCategory?> getTableCategoryById(String categoryId) async {
    return tableCategories[categoryId];
  }

  @override
  Future<TableCategory> update(TableCategory category) {
    throw UnimplementedError();
  }

  @override
  Stream<List<TableCategory>> watchAllCategory(String restaurantId) {
    throw UnimplementedError();
  }

  @override
  Stream<TableCategory> watchCurrentCategory(String categoryId) {
    throw UnimplementedError();
  }
}

final categoryA = TableCategory(
  id: _uuid.v4(),  
  type: "Type A",
  minSeat: 1,
  seatAmount: 2,
);
final categoryB = TableCategory(
  id: _uuid.v4(),  
  type: "Type B",
  minSeat: 3,
  seatAmount: 4,
);
final categoryC = TableCategory(
  id: _uuid.v4(),  
  type: "Type C",
  minSeat: 5,
  seatAmount: 6,
);

List<TableCategory> mockTableCategories = [categoryA, categoryB, categoryC];
