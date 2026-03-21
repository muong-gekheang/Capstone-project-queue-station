import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';

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

  // @override
  // Future<(List<MenuItem>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
  //   String restaurantId,
  //   int limit,
  //   DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  // ) async {
  //   Query<Map<String, dynamic>> query = fireStore
  //       .collection('menu_items')
  //       .where('restaurantId', isEqualTo: restaurantId)
  //       .orderBy('name')
  //       .limit(limit);

  //   if (lastDoc != null) {
  //     query = query.startAfterDocument(lastDoc);
  //   }

  //   final snap = await query.get();
  //   final menuItems = snap.docs.map((doc) {
  //     final json = Map<String, dynamic>.from(doc.data());
  //     json['id'] ??= doc.id;
  //     return MenuItem.fromJson(json);
  //   }).toList();

  //   final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
  //   return (menuItems, nextCursor);
  // }

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

    final menuItems = <MenuItem>[];

    for (final doc in snap.docs) {
      final json = doc.data();

      // Load sizes using the sizeOptionIds
      final sizeOptionIds = List<String>.from(json['menuSizeOptionIds'] ?? []);
      final sizes = await _loadSizes(sizeOptionIds);

      // Load add-ons using the addOnIds
      final addOnIds = List<String>.from(json['addOnIds'] ?? []);
      final addOns = await _loadAddOns(addOnIds);

      // Load category
      final category = await _loadCategory(json['categoryId'] ?? '');

      // Create MenuItem manually, not using fromJson
      final menuItem = MenuItem(
        id: doc.id,
        image: json['image'],
        name: json['name'],
        description: json['description'],
        minPrepTimeMinutes: json['minPrepTimeMinutes'],
        maxPrepTimeMinutes: json['maxPrepTimeMinutes'],
        categoryId: json['categoryId'],
        category: category,
        sizeOptionIds: sizeOptionIds,
        addOnIds: addOnIds,
        sizes: sizes,
        addOns: addOns,
        isAvailable: json['isAvailable'] ?? true,
      );

      menuItems.add(menuItem);
    }

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (menuItems, nextCursor);
  }

  // Helper methods to load related data
  Future<List<MenuSize>> _loadSizes(List<String> sizeOptionIds) async {
    if (sizeOptionIds.isEmpty) return [];

    final sizes = <MenuSize>[];

    // Load each size document from the 'sizes' collection
    for (final sizeId in sizeOptionIds) {
      final sizeDoc = await fireStore.collection('sizes').doc(sizeId).get();
      if (sizeDoc.exists) {
        final sizeJson = sizeDoc.data()!;

        // Load the referenced SizeOption
        final sizeOptionId =
            sizeJson['sizeOptionId']; // This should reference a SizeOption document
        SizeOption sizeOption;

        if (sizeOptionId != null) {
          // Load the SizeOption from the 'size_options' collection
          final sizeOptionDoc = await fireStore
              .collection('size_options')
              .doc(sizeOptionId)
              .get();

          if (sizeOptionDoc.exists) {
            final sizeOptionJson = sizeOptionDoc.data()!;
            sizeOption = SizeOption(name: sizeOptionJson['name'] ?? 'Unknown');
          } else {
            sizeOption = const SizeOption(name: 'Unknown');
          }
        } else {
          // Fallback if sizeOptionId is missing
          sizeOption = SizeOption(
            name: sizeJson['sizeOption']?['name'] ?? 'Unknown',
          );
        }

        sizes.add(
          MenuSize(
            price: (sizeJson['price'] as num?)?.toDouble() ?? 0.0,
            sizeOption: sizeOption,
          ),
        );
      }
    }

    return sizes;
  }

  Future<List<AddOn>> _loadAddOns(List<String> addOnIds) async {
    if (addOnIds.isEmpty) return [];

    final addOns = <AddOn>[];

    for (final addOnId in addOnIds) {
      final addOnDoc = await fireStore.collection('add_ons').doc(addOnId).get();
      if (addOnDoc.exists) {
        final addOnJson = addOnDoc.data()!;
        addOns.add(
          AddOn(
            id: addOnId,
            name: addOnJson['name'],
            price: (addOnJson['price'] as num).toDouble(),
            image: addOnJson['image'],
          ),
        );
      }
    }

    return addOns;
  }

  Future<MenuItemCategory?> _loadCategory(String categoryId) async {
    if (categoryId.isEmpty) return null;

    final categoryDoc = await fireStore
        .collection('menu_item_categories')
        .doc(categoryId)
        .get();

    if (categoryDoc.exists) {
      final categoryJson = categoryDoc.data()!;
      return MenuItemCategory(
        id: categoryId,
        name: categoryJson['name'],
        imageLink: categoryJson['imageLink'],
      );
    }

    return null;
  }

  @override
  Future<MenuItem?> getMenuItemById(String menuItemId) async {
    final doc = await fireStore.collection('menu_items').doc(menuItemId).get();
    if (!doc.exists) return null;

    final json = doc.data()!;

    // Load related data
    final sizeOptionIds = List<String>.from(json['menuSizeOptionIds'] ?? []);
    final sizes = await _loadSizes(sizeOptionIds);

    final addOnIds = List<String>.from(json['addOnIds'] ?? []);
    final addOns = await _loadAddOns(addOnIds);

    final category = await _loadCategory(json['categoryId'] ?? '');

    return MenuItem(
      id: doc.id,
      image: json['image'],
      name: json['name'],
      description: json['description'],
      minPrepTimeMinutes: json['minPrepTimeMinutes'],
      maxPrepTimeMinutes: json['maxPrepTimeMinutes'],
      categoryId: json['categoryId'],
      category: category,
      sizeOptionIds: sizeOptionIds,
      addOnIds: addOnIds,
      sizes: sizes,
      addOns: addOns,
      isAvailable: json['isAvailable'] ?? true,
    );
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
        final json = doc.data();
        final name = (json['name'] as String? ?? '').toLowerCase();
        final description = (json['description'] as String? ?? '')
            .toLowerCase();
        final categoryId = (json['categoryId'] as String? ?? '').toLowerCase();
        final isMatch =
            name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            categoryId.contains(searchQuery);

        if (!isMatch) continue;

        // Load related data (same as getAll)
        final sizeOptionIds = List<String>.from(json['menuSizeOptionIds'] ?? []);
        final sizes = await _loadSizes(sizeOptionIds);

        final addOnIds = List<String>.from(json['addOnIds'] ?? []);
        final addOns = await _loadAddOns(addOnIds);

        final category = await _loadCategory(json['categoryId'] ?? '');

        final menuItem = MenuItem(
          id: doc.id,
          image: json['image'],
          name: json['name'],
          description: json['description'],
          minPrepTimeMinutes: json['minPrepTimeMinutes'],
          maxPrepTimeMinutes: json['maxPrepTimeMinutes'],
          categoryId: json['categoryId'],
          category: category,
          sizeOptionIds: sizeOptionIds,
          addOnIds: addOnIds,
          sizes: sizes,
          addOns: addOns,
          isAvailable: json['isAvailable'] ?? true,
        );

        matchedMenuItems.add(menuItem);
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
        .map((snap) => snap.docs.map((doc) {
          final json = Map<String, dynamic>.from(doc.data());
          json['id'] ??= doc.id;
          return MenuItem.fromJson(json);
        }).toList());
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

    final menuItems = <MenuItem>[];

    for (final doc in snap.docs) {
      final json = doc.data();

      // Load related data
      final sizeOptionIds = List<String>.from(json['menuSizeOptionIds'] ?? []);
      final sizes = await _loadSizes(sizeOptionIds);

      final addOnIds = List<String>.from(json['addOnIds'] ?? []);
      final addOns = await _loadAddOns(addOnIds);

      final category = await _loadCategory(json['categoryId'] ?? '');

      final menuItem = MenuItem(
        id: doc.id,
        image: json['image'],
        name: json['name'],
        description: json['description'],
        minPrepTimeMinutes: json['minPrepTimeMinutes'],
        maxPrepTimeMinutes: json['maxPrepTimeMinutes'],
        categoryId: json['categoryId'],
        category: category,
        sizeOptionIds: sizeOptionIds,
        addOnIds: addOnIds,
        sizes: sizes,
        addOns: addOns,
        isAvailable: json['isAvailable'] ?? true,
      );

      menuItems.add(menuItem);
    }

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (menuItems, nextCursor);
  }
}
