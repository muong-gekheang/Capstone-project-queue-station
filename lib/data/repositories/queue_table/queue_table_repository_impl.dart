import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';

class QueueTableRepositoryImpl implements QueueTableRepository {
  final FirebaseFirestore fireStore;

  QueueTableRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(QueueTable table) async {
    final tableRef = fireStore.collection('queue_tables').doc(table.id);
    final tableJson = Map<String, dynamic>.from(table.toJson());
    await tableRef.set(tableJson);
  }

  @override
  Future<void> delete(String tableId) async {
    final docRef = fireStore.collection('queue_tables').doc(tableId);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final json = Map<String, dynamic>.from(doc.data()!);
    final status = (json['tableStatus'] as String? ?? '').toLowerCase();
    if (status != TableStatus.available.name) {
      throw StateError(
        'Cannot delete table "$tableId" because it is not available.',
      );
    }

    await docRef.delete();
  }

  @override
  Future<void> deleteMany(List<String> ids) async {
    if (ids.isEmpty) return;

    final docs = await Future.wait(
      ids.map((id) => fireStore.collection('queue_tables').doc(id).get()),
    );

    for (final doc in docs) {
      if (!doc.exists) continue;
      final json = Map<String, dynamic>.from(doc.data()!);
      final status = (json['tableStatus'] as String? ?? '').toLowerCase();
      if (status != TableStatus.available.name) {
        throw StateError(
          'Cannot delete table "${doc.id}" because it is not available.',
        );
      }
    }

    final batch = fireStore.batch();
    for (final id in ids) {
      batch.delete(fireStore.collection('queue_tables').doc(id));
    }
    await batch.commit();
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('queue_tables')
        .orderBy('tableNum')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final tables = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueTable.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (tables, nextCursor);
  }

  @override
  Future<QueueTable?> getQueueTableById(String tableId) async {
    final doc = await fireStore.collection('queue_tables').doc(tableId).get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return QueueTable.fromJson(json);
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchQueueTables(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) return getAll(limit, lastDoc);

    final matchedTables = <QueueTable>[];
    DocumentSnapshot<Map<String, dynamic>>? cursor = lastDoc;
    final batchSize = limit <= 0 ? 20 : limit * 3;

    while (matchedTables.length < limit) {
      Query<Map<String, dynamic>> firestoreQuery = fireStore
          .collection('queue_tables')
          .orderBy('tableNum')
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
        final tableNum = (json['tableNum'] as String? ?? '').toLowerCase();
        final tableStatus = (json['tableStatus'] as String? ?? '')
            .toLowerCase();
        final tableCategoryId = (json['tableCategoryId'] as String? ?? '')
            .toLowerCase();
        final isMatch =
            tableNum.contains(searchQuery) ||
            tableStatus.contains(searchQuery) ||
            tableCategoryId.contains(searchQuery);

        if (!isMatch) continue;

        json['id'] ??= doc.id;
        matchedTables.add(QueueTable.fromJson(json));
        if (matchedTables.length >= limit) break;
      }

      cursor = snap.docs.last;
      if (snap.docs.length < batchSize) {
        cursor = null;
        break;
      }
    }

    return (matchedTables, cursor);
  }

  @override
  Future<QueueTable> update(QueueTable table) async {
    final tableRef = fireStore.collection('queue_tables').doc(table.id);
    final tableJson = Map<String, dynamic>.from(table.toJson());
    await tableRef.update(tableJson);
    return table;
  }

  @override
  Stream<List<QueueTable>> watchAllQueueTable(String restId) {
    return fireStore
        .collection('queue_tables')
        .where('restaurantId', whereIn: [restId])
        .orderBy('tableNum')
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return QueueTable.fromJson(json);
          }).toList(),
        );
  }

  @override
  Stream<QueueTable> watchCurrentQueueTable() {
    return watchAllQueueTable(
      "",
    ).where((tables) => tables.isNotEmpty).map((tables) => tables.first);
  }

  @override
  Future<(List<QueueTable>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('queue_tables')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('tableNum')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final tables = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueTable.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (tables, nextCursor);
  }
}
