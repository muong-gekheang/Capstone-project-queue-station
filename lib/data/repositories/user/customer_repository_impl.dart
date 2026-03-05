import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/user/customer.dart';

class CustomerRepositoryImpl implements UserRepository {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<User?> _buildCustomerFromDoc(
    DocumentSnapshot<Map<String, dynamic>> docSnap,
  ) async {
    if (!docSnap.exists) return null;

    final data = docSnap.data();
    final type = data?['type'] ?? data?['userType'];
    if (data == null || type != 'customer') return null;

    final customerJson = <String, dynamic>{
      'id': docSnap.id,
      'name': data['name'],
      'email': data['email'],
      'phone': data['phone'],
      'histories': <Map<String, dynamic>>[],
      'currentHistory': null,
      'currentHistoryId': data['currentHistoryId'],
    };

    return Customer.fromJson(customerJson);
  }

  @override
  Future<User> create(User user) async {
    final userRef = fireStore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }

    // Histories are handled by history repository.
    if (user is Customer &&
        userJson['currentHistoryId'] == null &&
        user.currentHistory != null) {
      userJson['currentHistoryId'] = user.currentHistory!.id;
    }
    userJson.remove('histories');
    userJson.remove('currentHistory');

    await userRef.set(userJson);

    return user;
  }

  @override
  Future<void> delete(String id) async {
    final userRef = fireStore.collection('users').doc(id);

    while (true) {
      final historiesSnap = await userRef.collection('histories').limit(500).get();
      if (historiesSnap.docs.isEmpty) break;

      final batch = fireStore.batch();
      for (final doc in historiesSnap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await userRef.delete();
  }

  @override
  Future<List<User>> getAll({int? limit, String? search}) async {
    Query<Map<String, dynamic>> query = fireStore.collection('users');
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    final snap = await query.get();
    final normalizedSearch = search?.trim().toLowerCase();

    final users = <User>[];
    for (final doc in snap.docs) {
      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        final data = doc.data();
        final name = (data['name'] as String? ?? '').toLowerCase();
        final email = (data['email'] as String? ?? '').toLowerCase();
        final phone = (data['phone'] as String? ?? '').toLowerCase();

        final matches = name.contains(normalizedSearch) ||
            email.contains(normalizedSearch) ||
            phone.contains(normalizedSearch);
        if (!matches) continue;
      }

      final user = await _buildCustomerFromDoc(doc);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  @override
  Future<User?> getByEmail(String email) async {
    final snap = await fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildCustomerFromDoc(snap.docs.first);
  }

  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserById(String id) async {
    final docSnap = await fireStore.collection('users').doc(id).get();
    return _buildCustomerFromDoc(docSnap);
  }

  @override
  Future<User> update(User user) async {
    final userRef = fireStore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }

    if (user is Customer &&
        userJson['currentHistoryId'] == null &&
        user.currentHistory != null) {
      userJson['currentHistoryId'] = user.currentHistory!.id;
    }
    userJson.remove('histories');
    userJson.remove('currentHistory');

    await userRef.set(userJson, SetOptions(merge: true));

    return user;
  }

  @override
  Stream<User?> watchCurrentUser() {
    // TODO: implement watchCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User?> getByPhoneNumber(String phoneNumber) async {
    final snap = await fireStore
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildCustomerFromDoc(snap.docs.first);
  }
}
