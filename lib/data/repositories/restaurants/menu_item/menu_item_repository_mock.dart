// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:queue_station_app/data/menu_mock_data.dart';
// import 'package:queue_station_app/data/repositories/restaurants/menu_item_repository.dart';
// import 'package:queue_station_app/models/restaurant/menu_item.dart';

// class MenuItemRepositoryMock implements MenuItemRepository {
//   final List<MenuItem> _menuItems = allMenuItems;

//   @override
//   Future<void> create(MenuItem menuItem) {
//     // TODO: implement create
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> delete(String menuItemId) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> deleteMany(List<String> ids) {
//     // TODO: implement deleteMany
//     throw UnimplementedError();
//   }

//   @override
//   Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
//     int limit,
//     DocumentSnapshot<Map<String, dynamic>>? lastDoc,
//   ) async {
//     return (_menuItems.take(limit).toList(), null); 
//   }

//   @override
//   Future<List<MenuItem>> getManyMenuItemsById(List<String> ids) {
//     // TODO: implement getManyMenuItemsById
//     throw UnimplementedError();
//   }

//   @override
//   Future<MenuItem?> getMenuItemById(String menuItemId) {
//     // TODO: implement getMenuItemById
//     throw UnimplementedError();
//   }

//   @override
//   Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
//   getSearchMenuItems(
//     String query,
//     String? category,
//     int limit,
//     DocumentSnapshot<Map<String, dynamic>>? lastDoc,
//   ) async {
//     final filtered = _menuItems.where((item) {
//       final matchesQuery =
//           query.isEmpty ||
//           item.name.toLowerCase().contains(query.toLowerCase());

//       final matchesCategory =
//           category == null || category.isEmpty || item.category.id == category;

//       return matchesQuery && matchesCategory;
//     }).toList();

//     return (filtered.take(limit).toList(), null);
//   }

//   @override
//   Future<MenuItem> update(MenuItem menuItem) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<MenuItem>> watchAllMenuItem() {
//     // TODO: implement watchAllMenuItem
//     throw UnimplementedError();
//   }

//   @override
//   Stream<MenuItem> watchCurrentMenuItem() {
//     // TODO: implement watchCurrentMenuItem
//     throw UnimplementedError();
//   }
// }
