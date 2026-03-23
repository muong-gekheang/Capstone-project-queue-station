import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

class MenuItemRepositoryImpl implements MenuItemRepository {
  final FirebaseFirestore fireStore;

  MenuItemRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(MenuItem menuItem) async {
    final menuItemRef = fireStore.collection('menu_items').doc(menuItem.id);
    final menuItemJson = Map<String, dynamic>.from(menuItem.toJson());
    await menuItemRef.set(menuItemJson);
  }

  @override
  Future<void> delete(String menuItemId) async {
    await fireStore.collection('menu_items').doc(menuItemId).delete();
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('menu_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('name')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final menuItems = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return MenuItem.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (menuItems, nextCursor);
  }

  @override
  Future<MenuItem?> getMenuItemById(String menuItemId) async {
    final doc = await fireStore.collection('menu_items').doc(menuItemId).get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return MenuItem.fromJson(json);
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchMenuItems(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) return getAll(restaurantId, limit, lastDoc);

    final matchedMenuItems = <MenuItem>[];
    DocumentSnapshot<Map<String, dynamic>>? cursor = lastDoc;
    final batchSize = limit <= 0 ? 20 : limit * 3;

    while (matchedMenuItems.length < limit) {
      Query<Map<String, dynamic>> firestoreQuery = fireStore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('name')
          .limit(batchSize);

      if (cursor != null) {
        firestoreQuery = firestoreQuery.startAfterDocument(cursor);
      }

      final snap = await firestoreQuery.get();
      if (snap.docs.isEmpty) {
        cursor = null;
        break;
      }

      for (final doc in snap.docs) {
        final json = Map<String, dynamic>.from(doc.data());
        final name = (json['name'] as String? ?? '').toLowerCase();
        final description = (json['description'] as String? ?? '')
            .toLowerCase();
        final categoryId = (json['categoryId'] as String? ?? '').toLowerCase();
        final isMatch =
            name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            categoryId.contains(searchQuery);

        if (!isMatch) continue;

        json['id'] ??= doc.id;
        matchedMenuItems.add(MenuItem.fromJson(json));
        if (matchedMenuItems.length >= limit) break;
      }

      cursor = snap.docs.last;
      if (snap.docs.length < batchSize) {
        cursor = null;
        break;
      }
    }

    return (matchedMenuItems, cursor);
  }

  @override
  Future<MenuItem> update(MenuItem menuItem) async {
    final menuItemRef = fireStore.collection('menu_items').doc(menuItem.id);
    final menuItemJson = Map<String, dynamic>.from(menuItem.toJson());
    await menuItemRef.update(menuItemJson);
    return menuItem;
  }

  @override
  Stream<List<MenuItem>> watchAllMenuItem(String restaurantId) {
    return fireStore
        .collection('menu_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('name')
        .snapshots()
        .handleError((err) => debugPrint("Retrieval Error: $err"))
        .map(
          (snap) => snap.docs.map((doc) {
            debugPrint("Retrieval: ${doc.data()}");
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return MenuItem.fromJson(json);
          }).toList(),
        );
  }

  @override
  Stream<MenuItem> watchCurrentMenuItem(String menuItemId) {
    return fireStore
        .collection('menu_items')
        .doc(menuItemId)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) {
          final json = Map<String, dynamic>.from(doc.data()!);
          json['id'] ??= doc.id;
          return MenuItem.fromJson(json);
        });
  }

  @override
  Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)>
  getMenuItemByCategoryId(
    String restaurantId,
    String categoryId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('menu_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('name')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final menuItems = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return MenuItem.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (menuItems, nextCursor);
  }
}
