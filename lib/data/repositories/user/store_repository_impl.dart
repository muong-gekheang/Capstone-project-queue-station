import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';

class StoreRepositoryImpl implements UserRepository<StoreUser> {
  final FirebaseFirestore firestore;

  StoreRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<StoreUser?> _buildStoreFromDoc(
    DocumentSnapshot<Map<String, dynamic>> docSnap,
  ) async {
    if (!docSnap.exists) return null;

    final data = docSnap.data();
    final type = data?['userType'];
    if (data == null || type != 'store') return null;

    final storeJson = <String, dynamic>{
      'id': docSnap.id,
      'name': data['name'],
      'email': data['email'],
      'phone': data['phone'],
      'restaurantId': data['restaurantId'] ?? '',
    };

    return StoreUser.fromJson(storeJson);
  }

  @override
  Future<StoreUser> create(StoreUser user) async {
    final userRef = firestore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }

    await userRef.set(userJson);
    return user;
  }

  @override
  Future<void> delete(String id) async {
    await firestore.collection('users').doc(id).delete();
  }

  @override
  Future<List<StoreUser>> getAll({int? limit, String? search}) async {
    Query<Map<String, dynamic>> query = firestore.collection('users');
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    final snap = await query.get();
    final normalizedSearch = search?.trim().toLowerCase();

    final users = <StoreUser>[];
    for (final doc in snap.docs) {
      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        final data = doc.data();
        final name = (data['name'] as String? ?? '').toLowerCase();
        final email = (data['email'] as String? ?? '').toLowerCase();
        final phone = (data['phone'] as String? ?? '').toLowerCase();

        final matches =
            name.contains(normalizedSearch) ||
            email.contains(normalizedSearch) ||
            phone.contains(normalizedSearch);
        if (!matches) continue;
      }

      final user = await _buildStoreFromDoc(doc);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  @override
  Future<StoreUser?> getByEmail(String email) async {
    final snap = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildStoreFromDoc(snap.docs.first);
  }

  @override
  Future<StoreUser?> getByPhoneNumber(String phoneNumber) async {
    final snap = await firestore
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildStoreFromDoc(snap.docs.first);
  }

  @override
  Future<StoreUser?> getUserById(String id) async {
    final docSnap = await firestore.collection('users').doc(id).get();
    return _buildStoreFromDoc(docSnap);
  }

  @override
  Future<StoreUser> update(StoreUser user) async {
    final userRef = firestore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }
    
    await userRef.update(userJson);
    return user;
  }
}
