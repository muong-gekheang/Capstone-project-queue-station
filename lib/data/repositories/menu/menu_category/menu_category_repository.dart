import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';

abstract class MenuCategoryRepository {
  Future<void> create(MenuItemCategory category);
  Future<void> delete(String categoryId);
  Future<MenuItemCategory> update(MenuItemCategory category);
  Future<MenuItemCategory?> getMenuCategoryById(String categoryId);
  Future<(List<MenuItemCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc);
  Future<void> deleteMany(List<String> ids);
  Future<List<MenuItemCategory>> getManyMenuCategoriesById(List<String> ids);
  Stream<MenuItemCategory> watchCurrentMenuCategory(String menuCategoryId);
  Stream<List<MenuItemCategory>> watchAllMenuCategory(String restId);
}
