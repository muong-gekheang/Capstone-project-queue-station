import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/histories/history_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  QueueEntry _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = Map<String, dynamic>.from(doc.data() ?? <String, dynamic>{});
    json['id'] ??= doc.id;
    return QueueEntry.fromJson(json);
  }

  @override
  Future<void> create(QueueEntry history) async {
    final userRef = firestore.collection('users').doc(history.customerId);
    final historyRef = userRef.collection('histories').doc(history.id);

    final batch = firestore.batch();
    batch.set(historyRef, history.toJson());
    batch.set(userRef, {
      'currentHistoryId': history.id,
    }, SetOptions(merge: true));
    await batch.commit();
  }

  @override
  Future<void> delete(QueueEntry history) async {
    final userRef = firestore.collection('users').doc(history.customerId);
    final historyRef = userRef.collection('histories').doc(history.id);

    await firestore.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final data = userSnap.data();
      final currentHistoryId = data?['currentHistoryId'] as String?;

      tx.delete(historyRef);
      if (currentHistoryId == history.id) {
        tx.set(userRef, {'currentHistoryId': null}, SetOptions(merge: true));
      }
    });
  }

  @override
  Future<QueueEntry?> getCurrentHistoryByUserId(String userId) async {
    final userRef = firestore.collection('users').doc(userId);
    final userSnap = await userRef.get();

    if (!userSnap.exists) return null;

    final data = userSnap.data();
    final currentHistoryId = data?['currentHistoryId'] as String?;
    if (currentHistoryId == null || currentHistoryId.isEmpty) return null;

    final historySnap = await userRef
        .collection('histories')
        .doc(currentHistoryId)
        .get();
    if (!historySnap.exists) return null;
    return _fromDoc(historySnap);
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllHistoriesByUserId(
    String userId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = firestore
        .collection('users')
        .doc(userId)
        .collection('histories')
        .orderBy('id')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final snap = await query.get();
    final histories = snap.docs.map(_fromDoc).toList();
    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;

    return (histories, nextCursor);
  }

  @override
  Future<QueueEntry?> getHistoryById(String historyId) async {
    final snap = await firestore
        .collectionGroup('histories')
        .where('id', isEqualTo: historyId)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _fromDoc(snap.docs.first);
  }

  @override
  Future<QueueEntry> update(QueueEntry history) async {
    final userRef = firestore.collection('users').doc(history.customerId);
    final historyRef = userRef.collection('histories').doc(history.id);

    final isTerminal =
        history.status == QueueStatus.completed ||
        history.status == QueueStatus.cancelled ||
        history.status == QueueStatus.noShow;

    await firestore.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final userData = userSnap.data();
      final currentHistoryId = userData?['currentHistoryId'] as String?;

      tx.set(historyRef, history.toJson(), SetOptions(merge: true));

      if (isTerminal) {
        if (currentHistoryId == history.id) {
          tx.set(userRef, {'currentHistoryId': null}, SetOptions(merge: true));
        }
      } else {
        tx.set(userRef, {'currentHistoryId': history.id}, SetOptions(merge: true));
      }
    });

    return history;
  }

  @override
  Stream<QueueEntry?> watchCurrentHistory() {
    // TODO: implement watchCurrentHistory
    throw UnimplementedError();
  }

  @override
  Future<(List<QueueEntry>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAllHistoriesByRestaurantId(
    String restaurantId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = firestore
        .collectionGroup('histories')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('id')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final snap = await query.get();
    final histories = snap.docs.map(_fromDoc).toList();
    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;

    return (histories, nextCursor);
  }
  
  @override
  Stream<List<QueueEntry>> watchAllHistory() {
    // TODO: implement watchAllHistory
    throw UnimplementedError();
  }
}
