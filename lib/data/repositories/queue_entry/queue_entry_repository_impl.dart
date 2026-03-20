import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class QueueEntryRepositoryImpl implements QueueEntryRepository {
  final FirebaseFirestore fireStore;

  QueueEntryRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;
  @override
  Future<void> create(QueueEntry queueEntry) async {
    final queueEntryRef = fireStore
        .collection('queue_entries')
        .doc(queueEntry.id);

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
        .where('status', whereIn: ['waiting', 'serving']) 
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
  Stream<QueueEntry?> watchCurrentHistory(String customerId) {
    return fireStore
        .collection('queue_entries')
        .where('customerId', isEqualTo: customerId)
        .where('status', whereIn: ['waiting', 'serving'])
        .orderBy('joinTime', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;

          final json = Map<String, dynamic>.from(snapshot.docs.first.data());
          json['id'] ??= snapshot.docs.first.id;

          return QueueEntry.fromJson(json);
        });
  }
}
