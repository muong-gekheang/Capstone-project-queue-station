import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/restaurants/add_on_repository.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';

class AddOnRepositoryImpl implements AddOnRepository {
  final FirebaseFirestore fireStore;

  AddOnRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(AddOn addon) async {
    final addOnRef = fireStore.collection('add_ons').doc(addon.id);
    final addOnJson = Map<String, dynamic>.from(addon.toJson());
    await addOnRef.set(addOnJson);
  }

  @override
  Future<void> delete(String addOnId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) async {
    if (ids.isEmpty) return;

    final batch = fireStore.batch();
    for (final id in ids) {
      batch.delete(fireStore.collection('add_ons').doc(id));
    }
    await batch.commit();
  }

  @override
  Future<AddOn?> getAddOnById(String addOnId) async {
    final doc = await fireStore.collection('add_ons').doc(addOnId).get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return AddOn.fromJson(json);
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAddOnsByMenuItemId(
    String menuItemId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final menuItemDoc = await fireStore.collection('menu_items').doc(menuItemId).get();
    if (!menuItemDoc.exists) return (<AddOn>[], null);

    final menuItemJson = Map<String, dynamic>.from(menuItemDoc.data()!);
    final allAddOnIds = (menuItemJson['addOnIds'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    if (allAddOnIds.isEmpty) return (<AddOn>[], null);

    var startIndex = 0;
    if (lastDoc != null) {
      final lastIndex = allAddOnIds.indexOf(lastDoc.id);
      if (lastIndex != -1) {
        startIndex = lastIndex + 1;
      }
    }

    if (startIndex >= allAddOnIds.length || limit <= 0) {
      return (<AddOn>[], null);
    }

    final endIndex = (startIndex + limit > allAddOnIds.length)
        ? allAddOnIds.length
        : startIndex + limit;
    final pageIds = allAddOnIds.sublist(startIndex, endIndex);

    final docsById = <String, DocumentSnapshot<Map<String, dynamic>>>{};
    for (var i = 0; i < pageIds.length; i += 10) {
      final chunk = pageIds.sublist(
        i,
        i + 10 > pageIds.length ? pageIds.length : i + 10,
      );
      final snap = await fireStore
          .collection('add_ons')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        docsById[doc.id] = doc;
      }
    }

    final orderedDocs = <DocumentSnapshot<Map<String, dynamic>>>[];
    for (final id in pageIds) {
      final doc = docsById[id];
      if (doc != null) orderedDocs.add(doc);
    }

    final addOns = orderedDocs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data()!);
      json['id'] ??= doc.id;
      return AddOn.fromJson(json);
    }).toList();

    final nextCursor = orderedDocs.isEmpty || endIndex >= allAddOnIds.length
        ? null
        : orderedDocs.last;
    return (addOns, nextCursor);
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('add_ons')
        .orderBy('name')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final addOns = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return AddOn.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (addOns, nextCursor);
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getSearchAddOns(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) return getAll(limit, lastDoc);

    final matchedAddOns = <AddOn>[];
    DocumentSnapshot<Map<String, dynamic>>? cursor = lastDoc;
    final batchSize = limit <= 0 ? 20 : limit * 3;

    while (matchedAddOns.length < limit) {
      Query<Map<String, dynamic>> firestoreQuery = fireStore
          .collection('add_ons')
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
        if (!name.contains(searchQuery)) continue;

        json['id'] ??= doc.id;
        matchedAddOns.add(AddOn.fromJson(json));
        if (matchedAddOns.length >= limit) break;
      }

      cursor = snap.docs.last;
      if (snap.docs.length < batchSize) {
        cursor = null;
        break;
      }
    }

    return (matchedAddOns, cursor);
  }

  @override
  Future<AddOn> update(AddOn addon) async {
    final addOnRef = fireStore.collection('add_ons').doc(addon.id);
    final addOnJson = Map<String, dynamic>.from(addon.toJson());
    await addOnRef.update(addOnJson);
    return addon;
  }

  @override
  Stream<List<AddOn>> watchAllAddOn() {
    return fireStore
        .collection('add_ons')
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
          final json = Map<String, dynamic>.from(doc.data());
          json['id'] ??= doc.id;
          return AddOn.fromJson(json);
        }).toList());
  }

  @override
  Stream<AddOn> watchCurrentAddOn(String addOnId) {
    return fireStore
        .collection('add_ons')
        .doc(addOnId)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) {
          final json = Map<String, dynamic>.from(doc.data()!);
          json['id'] ??= doc.id;
          return AddOn.fromJson(json);
        });
  }
}
