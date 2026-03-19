import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/store_user.dart';

Future<void> seedDatabase({bool clearExisting = false}) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  final restId = 'rest_kh_1';
  final storeUserId = 'vDDDAYtdcvTn9Dg2YNkkSqvbLVI3';

  if (clearExisting) {
    await _deleteCollection(firestore, 'users');
    await _deleteCollection(firestore, 'restaurants');
    await _deleteCollection(firestore, 'table_categories');
    await _deleteCollection(firestore, 'queue_tables');
    await _deleteCollection(firestore, 'queue_entries');
    await _deleteCollection(firestore, 'menu_item_categories');
    await _deleteCollection(firestore, 'size_options');
    await _deleteCollection(firestore, 'add_ons');
    await _deleteCollection(firestore, 'menu_items');
    await _deleteCollection(firestore, 'order_items');
    await _deleteCollection(firestore, 'orders');
  }

  final restaurant = Restaurant(
    id: restId,
    name: 'Queue Cafe',
    address: 'Phnom Penh',
    logoLink: '',
    policy: 'Please arrive within 10 minutes of your call.',
    biggestTableSize: 8,
    phone: '023900001',
    isOpen: true,
    email: "queuecafe@gmail.com",
    subscriptionDate: now,
    subscriptionStatus: SubscriptionStatus.paid,
    openingTime: 8,
    closingTime: 11,
  );

  // 2. Create the Store User (linked to the restaurant)
  final storeUser = StoreUser(
    id: storeUserId,
    name: 'Alex ',
    email: 'sophanithmeas91@gmail.com',
    phone: '077000111',
    restaurantId: restId,
  );

  final batch = firestore.batch();

  // 3. Add to batch using .toJson()

  batch.set(
    firestore.collection('restaurants').doc(restId),
    restaurant.toJson(),
  );

  batch.set(firestore.collection('users').doc(storeUserId), storeUser.toJson());

  // 4. Commit the changes
  await batch.commit();
  print('Seed successful: Restaurant and User created.');
}

Future<void> _deleteCollection(
  FirebaseFirestore firestore,
  String collectionPath,
) async {
  const pageSize = 200;
  while (true) {
    final snapshot = await firestore
        .collection(collectionPath)
        .limit(pageSize)
        .get();
    if (snapshot.docs.isEmpty) break;

    final batch = firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
