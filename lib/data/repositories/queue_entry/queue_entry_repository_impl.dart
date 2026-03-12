import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class QueueEntryRepositoryImpl implements QueueEntryRepository {
  final FirebaseFirestore fireStore;

  QueueEntryRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;
  @override
  Future<void> create(QueueEntry queueEntry) async {
    final queueEntryRef = fireStore.doc(queueEntry.id);

    final queueEntryJson = queueEntry.toJson();

    await queueEntryRef.set(queueEntryJson);
  }

  @override
  Future<void> delete(QueueEntry queueEntry) async {}

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getCurrentByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('queue_entries')
        .where('restId', isEqualTo: restaurantId)
        .where('status', isEqualTo: 'waiting')
        .orderBy('joinTime', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final queueEntries = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueEntry.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (queueEntries, nextCursor);
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('queue_entries')
        .where('restId', isEqualTo: restaurantId)
        .orderBy('joinTime', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final queueEntries = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueEntry.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (queueEntries, nextCursor);
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getByCustomerId(
    String customerId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('queue_entries')
        .where('customerId', isEqualTo: customerId)
        .orderBy('joinTime', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final queueEntries = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueEntry.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (queueEntries, nextCursor);
  }

  @override
  Future<QueueEntry?> getCurrentByCustomerId(String customerId) async {
    final snap = await fireStore
        .collection('queue_entries')
        .where('customerId', isEqualTo: customerId)
        .where('status', isEqualTo: 'waiting')
        .orderBy('joinTime', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final json = Map<String, dynamic>.from(snap.docs.first.data());
    json['id'] ??= snap.docs.first.id;
    return QueueEntry.fromJson(json);
  }

  @override
  Future<QueueEntry?> getQueueEntryById(String queueId) async {
    final doc = await fireStore.collection('queue_entries').doc(queueId).get();
    if (!doc.exists) return null;

    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return QueueEntry.fromJson(json);
  }

  @override
  Future<QueueEntry> update(QueueEntry queueEntry) async {
    final queueEntryRef = fireStore
        .collection('queue_entries')
        .doc(queueEntry.id);
    final queueEntryJson = Map<String, dynamic>.from(queueEntry.toJson());

    await queueEntryRef.update(queueEntryJson);
    return queueEntry;
  }

  @override
  Stream<List<QueueEntry>> watchAllHistory() {
    // TODO: implement watchAllHistory
    throw UnimplementedError();
  }

  @override
  Stream<QueueEntry?> watchCurrentHistory() {
    // TODO: implement watchCurrentHistory
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getQueueHistory(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    var query = fireStore
        .collection('queueEntries')
        .where('restaurantId', isEqualTo: restaurantId)
        .where(
          'status',
          whereIn: [QueueStatus.completed.name, QueueStatus.serving.name],
        ) // Filter for both statuses
        .orderBy('joinTime', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    final queueEntries = snap.docs.map((doc) {
      final json = Map<String, dynamic>.from(doc.data());
      json['id'] ??= doc.id;
      return QueueEntry.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (queueEntries, nextCursor);
  }

  @override
  Stream<List<QueueEntry>> watchCurrentActiveQueue(String restId) {
    print("REST: $restId");
    final result = fireStore
        .collection('queueEntries')
        .where('restId', isEqualTo: restId)
        .where('status', isEqualTo: 'waiting')
        .orderBy('expectedTableReadyAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return QueueEntry.fromJson(json);
          }).toList();
        });
    return result;
  }

  @override
  Future<void> updateStatus(String id, QueueStatus newStatus) async {
    String? fieldToUpdate;
    switch (newStatus) {
      case QueueStatus.waiting:
        fieldToUpdate = null;
        break;
      case QueueStatus.serving:
        fieldToUpdate = "servedTime";
        break;
      case QueueStatus.completed:
        fieldToUpdate = "endedTime";
        break;
      case QueueStatus.cancelled:
        fieldToUpdate = "endedTime";
        break;
      case QueueStatus.noShow:
        fieldToUpdate = "endedTime";
        break;
    }
    await fireStore.collection('queue_entries').doc(id).update({
      'status': newStatus.name,
      if (fieldToUpdate != null) fieldToUpdate: DateTime.now(),
    });
  }
}
