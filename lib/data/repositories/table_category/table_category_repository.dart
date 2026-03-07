import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

abstract class TableCategoryRepository {
  Future<void> create(TableCategory category);
  Future<void> delete(String categoryId);
  Future<TableCategory> update(TableCategory category);
  Future<TableCategory?> getTableCategoryById(String categoryId);
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchCategories(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Future<List<TableCategory>> getManyTableCategoriesById(List<String> ids);
  Stream<TableCategory> watchCurrentCategory(String categoryId);
  Stream<List<TableCategory>> watchAllCategory(String restaurantId);
}
