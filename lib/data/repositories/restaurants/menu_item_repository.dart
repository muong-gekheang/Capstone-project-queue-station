import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

abstract class MenuItemRepository {
  Future<void> create(MenuItem menuItem);
  Future<void> delete(String menuItemId);
  Future<MenuItem> update(MenuItem menuItem);
  Future<MenuItem?> getMenuItemById(String menuItemId);
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchMenuItems(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getMenuItemByCategoryId(
    String restaurantId,
    String categoryId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Stream<MenuItem> watchCurrentMenuItem(String menuItemId);
  Stream<List<MenuItem>> watchAllMenuItem(String restaurantId);
}
