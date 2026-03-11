import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

class MenuItemRepositoryMock implements MenuItemRepository {
  Map<String, MenuItem> menuItems = {};

  MenuItemRepositoryMock() {
    for (var item in mockMenuItems) {
      menuItems[item.id] = item;
    }
  }
  @override
  Future<void> create(MenuItem menuItem) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String menuItemId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getMenuItemByCategoryId(
    String restaurantId,
    String categoryId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getMenuItemByCategoryId
    throw UnimplementedError();
  }

  @override
  Future<MenuItem?> getMenuItemById(String menuItemId) async {
    return menuItems[menuItemId];
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchMenuItems(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getSearchMenuItems
    throw UnimplementedError();
  }

  @override
  Future<MenuItem> update(MenuItem menuItem) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<MenuItem>> watchAllMenuItem(String restaurantId) {
    // TODO: implement watchAllMenuItem
    throw UnimplementedError();
  }

  @override
  Stream<MenuItem> watchCurrentMenuItem(String menuItemId) {
    // TODO: implement watchCurrentMenuItem
    throw UnimplementedError();
  }
}
