import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

abstract class MenuItemRepository {
  Future<void> create(MenuItem menuItem);
  Future<void> delete(String menuItemId);
  Future<MenuItem> update(MenuItem menuItem);
  Future<MenuItem?> getMenuItemById(String menuItemId);
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchMenuItems(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Future<List<MenuItem>> getManyMenuItemsById(List<String> ids);
  Stream<MenuItem> watchCurrentMenuItem();
  Stream<List<MenuItem>> watchAllMenuItem();
}
