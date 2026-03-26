
import 'package:cloud_firestore/cloud_firestore.dart';
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
    await _deleteCollection(firestore, 'sizes'); // Add sizes collection
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
    subscriptionStatus: SubscriptionStatus.active,
    openingTime: 8,
    closingTime: 11,
  );

  final tableCategorySmallId = 'tbl_cat_small_1';
  final tableCategoryFamilyId = 'tbl_cat_family_1';
  final tableA1Id = 'table_a1';
  final tableB1Id = 'table_b1';

  final categoryBurgerId = 'cat_burger_1';
  final categoryDrinkId = 'cat_drink_1';

  // Size Options (global sizes)
  final sizeRegularOptionId = 'size_option_regular';
  final sizeLargeOptionId = 'size_option_large';

  // Actual sizes with prices (these go in 'sizes' collection)
  final sizeBurgerRegularId = 'size_burger_regular';
  final sizeBurgerLargeId = 'size_burger_large';
  final sizeColaRegularId = 'size_cola_regular';
  final sizeColaLargeId = 'size_cola_large';

  final addOnCheeseId = 'addon_cheese';
  final addOnBaconId = 'addon_bacon';

  final menuBurgerId = 'menu_burger_1';
  final menuColaId = 'menu_cola_1';

  final orderItem1Id = 'order_item_1';
  final orderItem2Id = 'order_item_2';
  final order1Id = 'order_1';

  final queueEntry1Id = 'queue_1001';
  final queueEntry2Id = 'queue_1002';

  final users = <String, Map<String, dynamic>>{
    'user_c_1': {
      'id': 'user_c_1',
      'name': 'Lina',
      'email': 'lina@example.com',
      'phone': '012345678',
      'userType': 'customer',
      'historyIds': [queueEntry1Id, queueEntry2Id],
      'currentHistoryId': queueEntry1Id,
    },
    'user_c_2': {
      'id': 'user_c_2',
      'name': 'John',
      'email': 'john@example.com',
      'phone': '098765432',
      'userType': 'customer',
      'historyIds': [],
      'currentHistoryId': null,
    },
    'user_s_1': {
      'id': 'user_s_1',
      'name': 'Alex',
      'email': 'alex@store.com',
      'phone': '077000111',
      'userType': 'store',
      'restaurantId': restId,
    },
  };

  final restaurants = <String, Map<String, dynamic>>{
    restId: {
      'id': restId,
      'name': 'Queue Cafe',
      'address': 'Phnom Penh',
      'logoLink': '',
      'policy': 'Please arrive within 10 minutes of your call.',
      'biggestTableSize': 8,
      'phone': '023900001',
      'itemIds': [menuBurgerId, menuColaId],
      'tableIds': [tableA1Id, tableB1Id],
      'globalAddOnIds': [addOnCheeseId, addOnBaconId],
      'globalSizeOptionIds': [
        sizeRegularOptionId,
        sizeLargeOptionId,
      ], // Size options (global)
      'currentInQueueIds': [queueEntry1Id],
    },
  };

  final tableCategories = <String, Map<String, dynamic>>{
    tableCategorySmallId: {
      'id': tableCategorySmallId,
      'restaurantId': restId,
      'type': 'Small',
      'minSeat': 1,
      'seatAmount': 2,
    },
    tableCategoryFamilyId: {
      'id': tableCategoryFamilyId,
      'restaurantId': restId,
      'type': 'Family',
      'minSeat': 3,
      'seatAmount': 6,
    },
  };

  final queueTables = <String, Map<String, dynamic>>{
    tableA1Id: {
      'id': tableA1Id,
      'restaurantId': restId,
      'tableNum': 'A1',
      'tableStatus': 'occupied',
      'tableCategoryId': tableCategorySmallId,
      'queueEntryIds': [queueEntry1Id],
    },
    tableB1Id: {
      'id': tableB1Id,
      'restaurantId': restId,
      'tableNum': 'B1',
      'tableStatus': 'available',
      'tableCategoryId': tableCategoryFamilyId,
      'queueEntryIds': <String>[],
    },
  };

  final menuItemCategories = <String, Map<String, dynamic>>{
    categoryBurgerId: {
      'id': categoryBurgerId,
      'name': 'Burgers',
      'imageLink': null,
      'restaurantId': restId,
    },
    categoryDrinkId: {
      'id': categoryDrinkId,
      'name': 'Drinks',
      'imageLink': null,
      'restaurantId': restId,
    },
  };

  // Size Options (global sizes available at restaurant)
  final sizeOptions = <String, Map<String, dynamic>>{
    sizeRegularOptionId: {'name': 'Regular', 'restaurantId': restId},
    sizeLargeOptionId: {'name': 'Large', 'restaurantId': restId},
  };

  // Actual sizes with prices (these are linked to menu items)
  final sizes = <String, Map<String, dynamic>>{
    sizeBurgerRegularId: {
      'id': sizeBurgerRegularId,
      'price': 5.5,
      'sizeOptionId': sizeRegularOptionId,
      'restaurantId': restId,
    },
    sizeBurgerLargeId: {
      'id': sizeBurgerLargeId,
      'price': 7.5,
      'sizeOptionId': sizeLargeOptionId,
      'restaurantId': restId,
    },
    sizeColaRegularId: {
      'id': sizeColaRegularId,
      'price': 1.5,
      'sizeOptionId': sizeRegularOptionId,
      'restaurantId': restId,
    },
    sizeColaLargeId: {
      'id': sizeColaLargeId,
      'price': 2.5,
      'sizeOptionId': sizeLargeOptionId,
      'restaurantId': restId,
    },
  };

  final addOns = <String, Map<String, dynamic>>{
    addOnCheeseId: {
      'id': addOnCheeseId,
      'name': 'Cheese',
      'price': 0.5,
      'image': null,
      'restaurantId': restId,
    },
    addOnBaconId: {
      'id': addOnBaconId,
      'name': 'Bacon',
      'price': 1.0,
      'image': null,
      'restaurantId': restId,
    },
  };

  final menuItems = <String, Map<String, dynamic>>{
    menuBurgerId: {
      'id': menuBurgerId,
      'image': null,
      'name': 'Classic Burger',
      'description': 'Beef patty with lettuce and sauce',
      'minPrepTimeMinutes': 8,
      'maxPrepTimeMinutes': 15,
      'categoryId': categoryBurgerId,
      'sizeOptionIds': [
        sizeBurgerRegularId,
        sizeBurgerLargeId,
      ], // References to sizes collection
      'addOnIds': [addOnCheeseId, addOnBaconId],
      'isAvailable': true,
      'restaurantId': restId,
    },
    menuColaId: {
      'id': menuColaId,
      'image': null,
      'name': 'Cola',
      'description': 'Chilled soft drink',
      'minPrepTimeMinutes': 1,
      'maxPrepTimeMinutes': 3,
      'categoryId': categoryDrinkId,
      'sizeOptionIds': [
        sizeColaRegularId,
        sizeColaLargeId,
      ], // References to sizes collection
      'addOnIds': <String>[],
      'isAvailable': true,
      'restaurantId': restId,
    },
  };

  final orderItems = <String, Map<String, dynamic>>{
    orderItem1Id: {
      'menuItemId': menuBurgerId,
      'addOns': {addOnCheeseId: 0.5, addOnBaconId: 1.0},
      'menuItemPrice': 5.5,
      'sizeName': 'Regular',
      'quantity': 1,
      'note': 'No onion please',
      'orderItemStatus': 'accepted',
      'restaurantId': restId,
    },
    orderItem2Id: {
      'menuItemId': menuColaId,
      'addOns': <String, double>{},
      'menuItemPrice': 1.5,
      'sizeName': 'Regular',
      'quantity': 2,
      'note': null,
      'orderItemStatus': 'pending',
      'restaurantId': restId,
    },
  };

  final orders = <String, Map<String, dynamic>>{
    order1Id: {
      'id': order1Id,
      'orderedIds': [orderItem1Id],
      'inCartIds': [orderItem2Id],
      'timestamp': now.toIso8601String(),
      'restaurantId': restId,
      'customerId': 'user_c_1',
    },
  };

  final queueEntries = <String, Map<String, dynamic>>{
    queueEntry1Id: {
      'id': queueEntry1Id,
      'queueNumber': 'A001',
      'restId': restId,
      'customerId': 'user_c_1',
      'partySize': 2,
      'joinTime': now.toIso8601String(),
      'servedTime': null,
      'endedTime': null,
      'expectedTableReadyAt': now
          .add(const Duration(minutes: 25))
          .toIso8601String(),
      'status': 'waiting',
      'joinedMethod': 'remote',
      'tableNumber': 'A1',
      'orderId': order1Id,
    },
    queueEntry2Id: {
      'id': queueEntry2Id,
      'queueNumber': 'A000',
      'restId': restId,
      'customerId': 'user_c_1',
      'partySize': 2,
      'joinTime': now.subtract(const Duration(minutes: 40)).toIso8601String(),
      'servedTime': now.subtract(const Duration(minutes: 20)).toIso8601String(),
      'endedTime': now.subtract(const Duration(minutes: 10)).toIso8601String(),
      'expectedTableReadyAt': null,
      'status': 'completed',
      'joinedMethod': 'walkIn',
      'tableNumber': 'A1',
      'orderId': order1Id,
    },
  };

  final batch = firestore.batch();

  for (final entry in users.entries) {
    batch.set(firestore.collection('users').doc(entry.key), entry.value);
  }
  for (final entry in restaurants.entries) {
    batch.set(firestore.collection('restaurants').doc(entry.key), entry.value);
  }
  for (final entry in tableCategories.entries) {
    batch.set(
      firestore.collection('table_categories').doc(entry.key),
      entry.value,
    );
  }
  for (final entry in queueTables.entries) {
    batch.set(firestore.collection('queue_tables').doc(entry.key), entry.value);
  }
  for (final entry in menuItemCategories.entries) {
    batch.set(
      firestore.collection('menu_item_categories').doc(entry.key),
      entry.value,
    );
  }
  for (final entry in sizeOptions.entries) {
    batch.set(firestore.collection('size_options').doc(entry.key), entry.value);
  }
  // Add sizes collection
  for (final entry in sizes.entries) {
    batch.set(firestore.collection('sizes').doc(entry.key), entry.value);
  }
  for (final entry in addOns.entries) {
    batch.set(firestore.collection('add_ons').doc(entry.key), entry.value);
  }
  for (final entry in menuItems.entries) {
    batch.set(firestore.collection('menu_items').doc(entry.key), entry.value);
  }
  for (final entry in orderItems.entries) {
    batch.set(firestore.collection('order_items').doc(entry.key), entry.value);
  }
  for (final entry in orders.entries) {
    batch.set(firestore.collection('orders').doc(entry.key), entry.value);
  }
  for (final entry in queueEntries.entries) {
    batch.set(
      firestore.collection('queue_entries').doc(entry.key),
      entry.value,
    );
  }
  // 2. Create the Store User (linked to the restaurant)
  final storeUser = StoreUser(
    id: storeUserId,
    name: 'Alex ',
    email: 'sophanithmeas91@gmail.com',
    phone: '077000111',
    restaurantId: restId,
  );

  //final batch = firestore.batch();

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
