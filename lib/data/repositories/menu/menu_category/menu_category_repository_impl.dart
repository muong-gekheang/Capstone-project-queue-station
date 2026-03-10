import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';

class MenuCategoryRepositoryImpl implements MenuCategoryRepository {
  final FirebaseFirestore fireStore;

  MenuCategoryRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(MenuItemCategory category) async {
    final categoryRef = fireStore
        .collection('menu_item_categories')
        .doc(category.id);
    final categoryJson = Map<String, dynamic>.from(category.toJson());
    await categoryRef.set(categoryJson);
  }

  @override
  Future<void> delete(String categoryId) async {
    // How should we handle it?
    // cuz each category connects to many menuItem
    // await fireStore.collection('menu_item_categories').doc(categoryId).delete();
  }

  @override
  Future<(List<MenuItemCategory>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('menu_item_categories')
        .orderBy('name')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final categories = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return MenuItemCategory.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (categories, nextCursor);
  }

  @override
  Future<MenuItemCategory?> getMenuCategoryById(String categoryId) async {
    final doc = await fireStore
        .collection('menu_item_categories')
        .doc(categoryId)
        .get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return MenuItemCategory.fromJson(json);
  }

  @override
  Future<void> deleteMany(List<String> ids) async {
    if (ids.isEmpty) return;

    final batch = fireStore.batch();
    for (final id in ids) {
      batch.delete(fireStore.collection('menu_item_categories').doc(id));
    }
    await batch.commit();
  }

  @override
  Future<List<MenuItemCategory>> getManyMenuCategoriesById(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final categories = <MenuItemCategory>[];
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      final snap = await fireStore
          .collection('menu_item_categories')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      categories.addAll(
        snap.docs.map((doc) {
          final json = Map<String, dynamic>.from(doc.data());
          json['id'] ??= doc.id;
          return MenuItemCategory.fromJson(json);
        }),
      );
    }

    return categories;
  }

  @override
  Future<MenuItemCategory> update(MenuItemCategory category) async {
    final categoryRef = fireStore
        .collection('menu_item_categories')
        .doc(category.id);
    final categoryJson = Map<String, dynamic>.from(category.toJson());
    await categoryRef.update(categoryJson);
    return category;
  }

  @override
  Stream<MenuItemCategory> watchCurrentMenuCategory(String menuCategoryId) {
    return fireStore
        .collection('menu_item_categories')
        .doc(menuCategoryId)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) {
          final json = Map<String, dynamic>.from(doc.data()!);
          json['id'] ??= doc.id;
          return MenuItemCategory.fromJson(json);
        });
  }

  @override
  Stream<List<MenuItemCategory>> watchAllMenuCategory(String restId) {
    return fireStore
        .collection('menu_item_categories')
        .where("restaurantId", isEqualTo: restId)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return MenuItemCategory.fromJson(json);
          }).toList(),
        );
  }
}
