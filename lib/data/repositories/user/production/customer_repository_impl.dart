import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/user/customer.dart';

class CustomerRepositoryImpl implements UserRepository<Customer> {
  final FirebaseFirestore fireStore;

  CustomerRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  // Future<Customer?> _buildCustomerFromDoc(
  //   DocumentSnapshot<Map<String, dynamic>> docSnap,
  // ) async {
  //   if (!docSnap.exists) return null;

  //   final data = docSnap.data();
  //   final type = data?['userType'];
  //   if (data == null || type != 'customer') return null;

  //   final customerJson = <String, dynamic>{
  //     'id': docSnap.id,
  //     'name': data['name'],
  //     'email': data['email'],
  //     'phone': data['phone'],
  //     'historyIds': List<String>.from(data['historyIds'] ?? <String>[]),
  //     'currentHistoryId': data['currentHistoryId'],
  //   };

  //   return Customer.fromJson(customerJson);
  // }

  Future<Customer?> _buildCustomerFromDoc(
    DocumentSnapshot<Map<String, dynamic>> docSnap,
  ) async {
    if (!docSnap.exists) return null;

    final data = docSnap.data();
    print('Data from Firestore: $data'); // DEBUG
    print('historyIds value: ${data?['historyIds']}'); // DEBUG
    print('historyIds type: ${data?['historyIds'].runtimeType}'); // DEBUG

    final type = data?['userType'];
    if (data == null || type != 'customer') return null;

    final customerJson = <String, dynamic>{
      'id': docSnap.id,
      'name': data['name'],
      'email': data['email'],
      'phone': data['phone'],
      'historyIds': data['historyIds'] == null
          ? <String>[]
          : List<String>.from(data['historyIds']),
      'currentHistoryId': data['currentHistoryId'],
    };

    print('customerJson: $customerJson'); // DEBUG
    return Customer.fromJson(customerJson);
  }

  @override
  Future<Customer> create(Customer user) async {
    final userRef = fireStore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }

    // Histories are handled by history repository.
    if (userJson['currentHistoryId'] == null) {
      userJson['currentHistoryId'] = user.currentHistoryId;
    }
    userJson.remove('histories'); // Legacy key cleanup.
    userJson.remove('currentHistory'); // Legacy key cleanup.

    await userRef.set(userJson);

    return user;
  }

  @override
  Future<void> delete(String id) async {
    await fireStore.collection('users').doc(id).delete();
  }

  @override
  Future<List<Customer>> getAll({int? limit, String? search}) async {
    Query<Map<String, dynamic>> query = fireStore.collection('users');
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    final snap = await query.get();
    final normalizedSearch = search?.trim().toLowerCase();

    final users = <Customer>[];
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

      final user = await _buildCustomerFromDoc(doc);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  @override
  Future<Customer?> getByEmail(String email) async {
    final snap = await fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildCustomerFromDoc(snap.docs.first);
  }

  @override
  Future<Customer?> getUserById(String id) async {
    final docSnap = await fireStore.collection('users').doc(id).get();
    return _buildCustomerFromDoc(docSnap);
  }

  @override
  Future<Customer> update(Customer user) async {
    final userRef = fireStore.collection('users').doc(user.id);
    final userJson = Map<String, dynamic>.from(user.toJson());

    final type = userJson['userType'];
    if (type != null) {
      userJson['type'] = type;
    }

    if (userJson['currentHistoryId'] == null) {
      userJson['currentHistoryId'] = user.currentHistoryId;
    }
    userJson.remove('histories'); // Legacy key cleanup.
    userJson.remove('currentHistory'); // Legacy key cleanup.

    await userRef.update(userJson);
    return user;
  }

  @override
  Future<Customer?> getByPhoneNumber(String phoneNumber) async {
    final snap = await fireStore
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return _buildCustomerFromDoc(snap.docs.first);
  }
}
