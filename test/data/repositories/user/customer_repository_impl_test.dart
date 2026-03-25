import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:uuid/uuid.dart';

void main() {
  const uuid = Uuid();
  late FakeFirebaseFirestore firestore;
  late CustomerRepositoryImpl repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = CustomerRepositoryImpl(fireStore: firestore);
  });

  group('CustomerRepositoryImpl', () {
    test('create stores normalized customer fields', () async {
      final userId = uuid.v4();
      final user = Customer(
        id: userId,
        name: 'Lina',
        email: 'lina@example.com',
        phone: '012345678',
        historyIds: const ['q1'],
        currentHistoryId: 'q1',
      );

      await repository.create(user);

      final snap = await firestore.collection('users').doc(userId).get();
      final data = snap.data();

      expect(data, isNotNull);
      expect(data!['id'], userId);
      expect(data['userType'], 'customer');
      expect(data['historyIds'], ['q1']);
      expect(data['currentHistoryId'], 'q1');
      expect(data.containsKey('histories'), isFalse);
      expect(data.containsKey('currentHistory'), isFalse);

    });

    test('getUserById maps missing historyIds to empty list', () async {
      final userId = uuid.v4();
      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'name': 'John',
        'email': 'john@example.com',
        'phone': '098765432',
        'userType': 'customer',
      });

      final user = await repository.getUserById(userId);

      expect(user, isA<Customer>());
      final customer = user!;
      expect(customer.historyIds, isEmpty);
      expect(customer.currentHistoryId, isNull);
    });

    test('getAll search filters by name/email/phone and type', () async {
      final customer1Id = uuid.v4();
      final customer2Id = uuid.v4();
      final storeId = uuid.v4();

      await firestore.collection('users').doc(customer1Id).set({
        'id': customer1Id,
        'name': 'Alice',
        'email': 'alice@example.com',
        'phone': '011111111',
        'userType': 'customer',
        'historyIds': <String>[],
      });
      await firestore.collection('users').doc(customer2Id).set({
        'id': customer2Id,
        'name': 'Bob',
        'email': 'bob@example.com',
        'phone': '022222222',
        'userType': 'customer',
        'historyIds': <String>[],
      });
      await firestore.collection('users').doc(storeId).set({
        'id': storeId,
        'name': 'Store',
        'email': 'store@example.com',
        'phone': '033333333',
        'userType': 'store',
      });

      final result = await repository.getAll(search: 'alice');

      expect(result.length, 1);
      expect(result.first.id, customer1Id);
    });

    test('update merges fields and keeps schema normalized', () async {
      final userId = uuid.v4();
      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'name': 'Old',
        'email': 'old@example.com',
        'phone': '099999999',
        'userType': 'customer',
        'historyIds': <String>[],
        'currentHistoryId': null,
      });

      final updated = Customer(
        id: userId,
        name: 'New',
        email: 'new@example.com',
        phone: '088888888',
        historyIds: const ['q10', 'q11'],
        currentHistoryId: 'q11',
      );

      await repository.update(updated);

      final snap = await firestore.collection('users').doc(userId).get();
      final data = snap.data()!;

      expect(data['name'], 'New');
      expect(data['email'], 'new@example.com');
      expect(data['historyIds'], ['q10', 'q11']);
      expect(data['currentHistoryId'], 'q11');
      expect(data['userType'], 'customer');
      expect(data.containsKey('histories'), isFalse);
      expect(data.containsKey('currentHistory'), isFalse);
    });

    test('delete removes user document and keeps queue entries intact', () async {
      final userId = uuid.v4();
      final queueEntryId = uuid.v4();
      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'name': 'Del',
        'email': 'del@example.com',
        'phone': '077777777',
        'userType': 'customer',
        'historyIds': <String>[],
      });
      await firestore.collection('queue_entries').doc(queueEntryId).set({
        'id': queueEntryId,
        'customerId': userId,
        'status': 'waiting',
      });

      await repository.delete(userId);

      final userSnap = await firestore.collection('users').doc(userId).get();
      final queueSnap = await firestore
          .collection('queue_entries')
          .doc(queueEntryId)
          .get();
      final queueData = queueSnap.data();

      expect(userSnap.exists, isFalse);
      expect(queueSnap.exists, isTrue);
      expect(queueData?['customerId'], userId);
    });
  });
}
