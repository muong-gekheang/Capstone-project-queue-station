import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

class TableCategoryRepositoryImpl implements TableCategoryRepository {
  final FirebaseFirestore fireStore;

  TableCategoryRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(TableCategory category) async {
    final categoryRef = fireStore
        .collection('table_categories')
        .doc(category.id);
    final categoryJson = Map<String, dynamic>.from(category.toJson());
    await categoryRef.set(categoryJson);
  }

  @override
  Future<void> delete(String categoryId) async {
    final categoryRef = fireStore
        .collection('table_categories')
        .doc(categoryId);

    await categoryRef.delete();
  }

  @override
  Future<void> deleteMany(List<String> ids) async {
    if (ids.isEmpty) return;

    final batch = fireStore.batch();
    for (final id in ids) {
      batch.delete(fireStore.collection('table_categories').doc(id));
    }
    await batch.commit();
  }

  @override
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('table_categories')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('type')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final categories = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return TableCategory.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (categories, nextCursor);
  }

  @override
  Future<List<TableCategory>> getManyTableCategoriesById(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final categories = <TableCategory>[];
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      final snap = await fireStore
          .collection('table_categories')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      categories.addAll(
        snap.docs.map((doc) {
          final json = Map<String, dynamic>.from(doc.data());
          json['id'] ??= doc.id;
          return TableCategory.fromJson(json);
        }),
      );
    }

    return categories;
  }

  @override
  Future<(List<TableCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchCategories(
    String restaurantId,
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) return getAll(restaurantId, limit, lastDoc);

    final matchedCategories = <TableCategory>[];
    DocumentSnapshot<Map<String, dynamic>>? cursor = lastDoc;
    final batchSize = limit <= 0 ? 20 : limit * 3;

    while (matchedCategories.length < limit) {
      Query<Map<String, dynamic>> firestoreQuery = fireStore
          .collection('table_categories')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('type')
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
        final type = (json['type'] as String? ?? '').toLowerCase();
        if (!type.contains(searchQuery)) continue;

        json['id'] ??= doc.id;
        matchedCategories.add(TableCategory.fromJson(json));
        if (matchedCategories.length >= limit) break;
      }

      cursor = snap.docs.last;
      if (snap.docs.length < batchSize) {
        cursor = null;
        break;
      }
    }

    return (matchedCategories, cursor);
  }

  @override
  Future<TableCategory?> getTableCategoryById(String categoryId) async {
    final doc = await fireStore
        .collection('table_categories')
        .doc(categoryId)
        .get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return TableCategory.fromJson(json);
  }

  @override
  Future<TableCategory> update(TableCategory category) async {
    final categoryRef = fireStore
        .collection('table_categories')
        .doc(category.id);
    final categoryJson = Map<String, dynamic>.from(category.toJson());
    await categoryRef.update(categoryJson);
    return category;
  }

  @override
  Stream<List<TableCategory>> watchAllCategory(String restaurantId) {
    return fireStore
        .collection('table_categories')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('type')
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            debugPrint("Table Cat JSON: $json");
            final result = TableCategory.fromJson(json);
            debugPrint("Table Cat Result: $result");
            return result;
          }).toList(),
        )
        .handleError((err) => debugPrint("Stream table cat error: $err"));
  }

  @override
  Stream<TableCategory> watchCurrentCategory(String categoryId) {
    return fireStore
        .collection('table_categories')
        .doc(categoryId)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) {
          final json = Map<String, dynamic>.from(doc.data()!);
          json['id'] ??= doc.id;
          return TableCategory.fromJson(json);
        });
  }
}
