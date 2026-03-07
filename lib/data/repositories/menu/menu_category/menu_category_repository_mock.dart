import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';

class MenuCategoryRepositoryMock implements MenuCategoryRepository {
  Map<String, MenuItemCategory> menuCategories = {};

  MenuCategoryRepositoryMock() {
    for (var cat in mockMenuCategories) {
      menuCategories[cat.id] = cat;
    }
  }
  @override
  Future<void> create(MenuItemCategory category) {
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
  Future<(List<MenuItemCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemCategory>> getManyMenuCategoriesById(List<String> ids) {
    // TODO: implement getManyMenuCategoriesById
    throw UnimplementedError();
  }

  @override
  Future<MenuItemCategory?> getMenuCategoryById(String categoryId) async {
    return menuCategories[categoryId];
  }

  @override
  Future<MenuItemCategory> update(MenuItemCategory category) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<MenuItemCategory>> watchAllMenuCategory() {
    // TODO: implement watchAllMenuCategory
    throw UnimplementedError();
  }

  @override
  Stream<MenuItemCategory> watchCurrentMenuCategory(String menuCategoryId) {
    // TODO: implement watchCurrentMenuCategory
    throw UnimplementedError();
  }
}
