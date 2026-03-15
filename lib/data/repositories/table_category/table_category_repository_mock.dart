import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

class TableCategoryRepositoryMock implements TableCategoryRepository {
  Map<String, TableCategory> tableCategories = {};

  TableCategoryRepositoryMock() {
    for (var tableCat in mockTableCategories) {
      tableCategories[tableCat.id] = tableCat;
    }
  }
  @override
  Future<void> create(TableCategory category) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String categoryId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<TableCategory>> getManyTableCategoriesById(List<String> ids) {
    // TODO: implement getManyTableCategoriesById
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
    // TODO: implement getSearchCategories
    throw UnimplementedError();
  }

  @override
  Future<TableCategory?> getTableCategoryById(String categoryId) async {
    return tableCategories[categoryId];
  }

  @override
  Future<TableCategory> update(TableCategory category) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<TableCategory>> watchAllCategory(String restaurantId) {
    // TODO: implement watchAllCategory
    throw UnimplementedError();
  }

  @override
  Stream<TableCategory> watchCurrentCategory(String categoryId) {
    // TODO: implement watchCurrentCategory
    throw UnimplementedError();
  }
}

final categoryA = TableCategory(
  id: uuid.v4(),
  type: "Type A",
  minSeat: 1,
  seatAmount: 2,
  restaurantId: '',
);
final categoryB = TableCategory(
  id: uuid.v4(),
  type: "Type B",
  minSeat: 3,
  seatAmount: 4,
  restaurantId: '',
);
final categoryC = TableCategory(
  id: uuid.v4(),
  type: "Type C",
  minSeat: 5,
  seatAmount: 6,
  restaurantId: '',
);

List<TableCategory> mockTableCategories = [categoryA, categoryB, categoryC];
