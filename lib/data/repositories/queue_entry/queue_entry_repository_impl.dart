import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  Future<List<QueueEntry>> getTodayFinishedQueue(String restaurantId) async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      // 2. Build the query
      var query = fireStore
          .collection('queue_entries')
          .where('restId', isEqualTo: restaurantId)
          .where(
            'status',
            whereIn: [QueueStatus.completed.name, QueueStatus.serving.name],
          ) // Only finished
          .where(
            'joinTime',
            isGreaterThanOrEqualTo: startOfToday.toIso8601String(),
          )
          .orderBy('joinTime', descending: true);

      final snap = await query.get();

      return snap.docs.map((doc) {
        final json = Map<String, dynamic>.from(doc.data());
        json['id'] ??= doc.id;
        return QueueEntry.fromJson(json);
      }).toList();
    } catch (err) {
      debugPrint("ERROR in getTodayFinishedQueue: $err");
      return [];
    }
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getQueueHistory(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    try {
      var query = fireStore
          .collection('queue_entries')
          .where('restId', isEqualTo: restaurantId)
          .where(
            'status',
            whereIn: [QueueStatus.completed.name, QueueStatus.noShow.name],
          )
          .orderBy('joinTime', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snap = await query.get();
      final queueEntries = snap.docs.map((doc) {
        final json = Map<String, dynamic>.from(doc.data());
        json['id'] ??= doc.id;
        try {
          return QueueEntry.fromJson(json);
        } catch (e) {
          debugPrint("Mapping failed for document: ${doc.id}");
          debugPrint("JSON Data: $json"); // Look for fields that are null here!
          rethrow;
        }
      }).toList();
      print("RESULT: ${queueEntries.length}");
      final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
      return (queueEntries, nextCursor);
    } catch (err) {
      print("ERROR: $err");
      return (<QueueEntry>[], null);
    }
  }

  @override
  Stream<List<QueueEntry>> watchCurrentActiveQueue(String restId) {
    final result = fireStore
        .collection('queue_entries')
        .where('restId', isEqualTo: restId)
        .where('status', isEqualTo: 'waiting')
        .snapshots()
        .handleError((err) => print("Stream Error: $err"))
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            debugPrint(json.toString());

            json['id'] ??= doc.id;
            var result = QueueEntry.fromJson(json);
            return result;
          }).toList();
        });

    return result;
  }

  @override
  Stream<List<QueueEntry>> watchAllActiveQueues() {
    return fireStore
        .collection('queue_entries')
        .where('status', isEqualTo: 'waiting')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return QueueEntry.fromJson(json);
          }).toList();
        });
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
      ?fieldToUpdate: Timestamp.now(),
    });
  }

  @override
  Stream<QueueEntry?> watchQueueEntry(String queueEntryId) {
    return fireStore
        .collection('queue_entries')
        .doc(queueEntryId)
        .snapshots()
        .map((doc) {
          // 1. Check if document exists and has data
          final data = doc.data();
          if (!doc.exists || data == null) return null;

          try {
            // 2. Create a copy of data and ensure the ID is present
            final json = Map<String, dynamic>.from(data);
            json['id'] = doc.id;

            // 3. Parse into Model
            return QueueEntry.fromJson(json);
          } catch (e) {
            debugPrint('❌ Error parsing QueueEntry $queueEntryId: $e');
            return null;
          }
        });
  }

  @override
  Stream<List<QueueEntry>> watchCurrentInStore(String restId) {
    final result = fireStore
        .collection('queue_entries')
        .where('restId', isEqualTo: restId)
        .where('status', isEqualTo: 'serving')
        .snapshots()
        .handleError((err) => print("Stream Error: $err"))
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final json = Map<String, dynamic>.from(doc.data());
            debugPrint(json.toString());

            json['id'] ??= doc.id;
            var result = QueueEntry.fromJson(json);
            return result;
          }).toList();
        });

    return result;
  }
}
