import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';

abstract class MenuCategoryRepository {
  Future<void> create(MenuItemCategory category);
  Future<void> delete(String categoryId);
  Future<MenuItemCategory> update(MenuItemCategory category);
  Future<MenuItemCategory?> getCategoryById(String categoryId);
  Future<(List<MenuItemCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchCategories(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<MenuItemCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Future<List<MenuItemCategory>> getManyCategoriesById(List<String> ids);
  Stream<MenuItemCategory> watchCurrentCategory();
  Stream<List<MenuItemCategory>> watchAllCategory();
}
