// // import 'package:queue_station_app/data/mock_restaurant.dart';
// // import 'package:queue_station_app/models/restaurant/restaurant.dart';
// // import 'package:queue_station_app/models/user/customer.dart';
// // import 'package:queue_station_app/models/user/queue_entry.dart';
// // import 'package:queue_station_app/models/user/history.dart';
// // import 'package:queue_station_app/models/user/abstracts/user.dart';
// // import 'package:queue_station_app/models/user/store_user.dart';
// // import 'package:uuid/uuid.dart';

// // final Uuid uuid = Uuid();

// // // Example Restaurants
// // final restaurant1 = Restaurant(
// //   id: uuid.v4(),
// //   name: "Pizza Place",
// //   address: "123 Main St",
// //   logoLink: "https://example.com/logo1.png",
// //   biggestTableSize: 6,
// //   phone: "111-222-3333",
// //   items: [],
// //   tables: [],
// //   globalAddOns: [],
// //   globalSizeOptions: [],
// // );

// // final restaurant2 = Restaurant(
// //   id: uuid.v4(),
// //   name: "Burger Hub",
// //   address: "456 Elm St",
// //   logoLink: "https://example.com/logo2.png",
// //   biggestTableSize: 4,
// //   phone: "222-333-4444",
// //   items: [],
// //   tables: [],
// //   globalAddOns: [],
// //   globalSizeOptions: [],
// // );

// // final restaurant3 = Restaurant(
// //   id: uuid.v4(),
// //   name: "Sushi Spot",
// //   address: "789 Oak St",
// //   logoLink: "https://example.com/logo3.png",
// //   biggestTableSize: 8,
// //   phone: "333-444-5555",
// //   items: [],
// //   tables: [],
// //   globalAddOns: [],
// //   globalSizeOptions: [],
// // );

// // // Example QueueEntries
// // final queue1 = QueueEntry(
// //   id: uuid.v4(),
// //   customerId: "user1",
// //   partySize: 2,
// //   joinTime: DateTime(2026, 1, 26, 10, 15),
// //   servedTime: DateTime(2026, 1, 26, 10, 22),
// //   status: QueueStatus.completed,
// //   queueNumber: 'A101',
// //   joinedMethod: JoinedMethod.walkIn,
// // );

// // final queue2 = QueueEntry(
// //   id: uuid.v4(),
// //   customerId: "user1",
// //   partySize: 2,
// //   joinTime: DateTime(2026, 1, 26, 11, 0),
// //   servedTime: DateTime(2026, 1, 26, 11, 10),
// //   status: QueueStatus.serving,
// //   queueNumber: 'B107',
// //   joinedMethod: JoinedMethod.remote,
// // );

// // final queue3 = QueueEntry(
// //   id: uuid.v4(),
// //   customerId: "user2",
// //   partySize: 3,
// //   joinTime: DateTime(2026, 1, 26, 11, 5),
// //   servedTime: DateTime(2026, 1, 26, 11, 20),
// //   status: QueueStatus.completed,
// //   queueNumber: 'A102',
// //   joinedMethod: JoinedMethod.walkIn,
// // );

// // final queue4 = QueueEntry(
// //   id: uuid.v4(),
// //   customerId: "user3",
// //   partySize: 1,
// //   joinTime: DateTime(2026, 1, 26, 12, 0),
// //   servedTime: null,
// //   status: QueueStatus.waiting,
// //   queueNumber: 'C202',
// //   joinedMethod: JoinedMethod.remote,
// // );

// // final queue5 = QueueEntry(
// //   id: uuid.v4(),
// //   customerId: "user3",
// //   partySize: 4,
// //   joinTime: DateTime(2026, 1, 26, 12, 30),
// //   servedTime: DateTime(2026, 1, 26, 12, 50),
// //   status: QueueStatus.completed,
// //   queueNumber: 'B102',
// //   joinedMethod: JoinedMethod.remote,
// // );

// // // Example Histories
// // final history1 = History(
// //   rest: restaurant1,
// //   queue: queue1,
// //   userId: "user1",
// //   id: Uuid().v4(),
// // );
// // final history2 = History(
// //   rest: restaurant1,
// //   queue: queue2,
// //   userId: "user1",
// //   id: Uuid().v4(),
// // );
// // final history3 = History(
// //   rest: restaurant2,
// //   queue: queue3,
// //   userId: "user2",
// //   id: Uuid().v4(),
// // );
// // final history4 = History(
// //   rest: restaurant1,
// //   queue: queue4,
// //   userId: "user3",
// //   id: Uuid().v4(),
// // );
// // final history5 = History(
// //   rest: restaurant3,
// //   queue: queue5,
// //   userId: "user3",
// //   id: Uuid().v4(),
// // );

// // final List<History> mockHistories = [
// //   history1,
// //   history2,
// //   history3,
// //   history4,
// //   history5,
// // ];

// // // Example Users
// // final user1 = Customer(
// //   id: "user1",
// //   name: "Alice",
// //   email: "alice@example.com",
// //   phone: "1234567890",
// //   histories: [
// //     history1,
// //     history2,
// //     history3,
// //     history3,
// //     history3,
// //     history3,
// //     history3,
// //   ],
// // );

// // final user2 = StoreUser(
// //   id: "user2",
// //   name: "Bob",
// //   email: "bob@example.com",
// //   phone: "0987654321",
// //   rest: mockRestaurants[0],
// // );

// // // For admin later
// // // final user3 = User(
// // //   id: "user3",
// // //   name: "Charlie",
// // //   email: "charlie@example.com",
// // //   phone: "1122334455",
// // //   userType: UserType.normal,
// // //   currentHistory: history4,
// // //   histories: [history4, history5],
// // // );

// // // List of all users
// // final List<User> mockUsers = [user1, user2];

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:queue_station_app/data/mock_restaurant.dart';
// import 'package:queue_station_app/models/restaurant/restaurant.dart';
// import 'package:queue_station_app/models/user/customer.dart';
// import 'package:queue_station_app/models/user/queue_entry.dart';
// import 'package:queue_station_app/models/user/history.dart';
// import 'package:queue_station_app/models/user/abstracts/user.dart';
// import 'package:queue_station_app/models/user/store_user.dart';
// import 'package:uuid/uuid.dart';

// final Uuid uuid = Uuid();

// // Example Restaurants
// final restaurant1 = Restaurant(
//   id: uuid.v4(),
//   name: "Pizza Place",
//   address: "123 Main St",
//   logoLink: "https://example.com/logo1.png",
//   biggestTableSize: 6,
//   phone: "111-222-3333",
//   items: [],
//   tables: [],
//   globalAddOns: [],
//   globalSizeOptions: [],
//   // --- Missing Fields Added ---
//   location: const LatLng(11.556, 104.928),
//   contactDetails: [],
// );

// final restaurant2 = Restaurant(
//   id: uuid.v4(),
//   name: "Burger Hub",
//   address: "456 Elm St",
//   logoLink: "https://example.com/logo2.png",
//   biggestTableSize: 4,
//   phone: "222-333-4444",
//   items: [],
//   tables: [],
//   globalAddOns: [],
//   globalSizeOptions: [],
//   // --- Missing Fields Added ---
//   location: const LatLng(11.560, 104.920),
//   contactDetails: [],
// );

// final restaurant3 = Restaurant(
//   id: uuid.v4(),
//   name: "Sushi Spot",
//   address: "789 Oak St",
//   logoLink: "https://example.com/logo3.png",
//   biggestTableSize: 8,
//   phone: "333-444-5555",
//   items: [],
//   tables: [],
//   globalAddOns: [],
//   globalSizeOptions: [],
//   // --- Missing Fields Added ---
//   location: const LatLng(11.590, 104.880),
//   contactDetails: [],
// );

// // Example QueueEntries
// final queue1 = QueueEntry(
//   id: uuid.v4(),
//   customerId: "user1",
//   partySize: 2,
//   joinTime: DateTime(2026, 1, 26, 10, 15),
//   servedTime: DateTime(2026, 1, 26, 10, 22),
//   status: QueueStatus.completed,
//   queueNumber: 'A101',
//   joinedMethod: JoinedMethod.walkIn,
// );

// final queue2 = QueueEntry(
//   id: uuid.v4(),
//   customerId: "user1",
//   partySize: 2,
//   joinTime: DateTime(2026, 1, 26, 11, 0),
//   servedTime: DateTime(2026, 1, 26, 11, 10),
//   status: QueueStatus.serving,
//   queueNumber: 'B107',
//   joinedMethod: JoinedMethod.remote,
// );

// final queue3 = QueueEntry(
//   id: uuid.v4(),
//   customerId: "user2",
//   partySize: 3,
//   joinTime: DateTime(2026, 1, 26, 11, 5),
//   servedTime: DateTime(2026, 1, 26, 11, 20),
//   status: QueueStatus.completed,
//   queueNumber: 'A102',
//   joinedMethod: JoinedMethod.walkIn,
// );

// final queue4 = QueueEntry(
//   id: uuid.v4(),
//   customerId: "user3",
//   partySize: 1,
//   joinTime: DateTime(2026, 1, 26, 12, 0),
//   servedTime: null,
//   status: QueueStatus.waiting,
//   queueNumber: 'C202',
//   joinedMethod: JoinedMethod.remote,
// );

// final queue5 = QueueEntry(
//   id: uuid.v4(),
//   customerId: "user3",
//   partySize: 4,
//   joinTime: DateTime(2026, 1, 26, 12, 30),
//   servedTime: DateTime(2026, 1, 26, 12, 50),
//   status: QueueStatus.completed,
//   queueNumber: 'B102',
//   joinedMethod: JoinedMethod.remote,
// );

// // Example Histories
// final history1 = History(
//   rest: restaurant1,
//   queue: queue1,
//   userId: "user1",
//   id: Uuid().v4(),
// );
// final history2 = History(
//   rest: restaurant1,
//   queue: queue2,
//   userId: "user1",
//   id: Uuid().v4(),
// );
// final history3 = History(
//   rest: restaurant2,
//   queue: queue3,
//   userId: "user2",
//   id: Uuid().v4(),
// );
// final history4 = History(
//   rest: restaurant1,
//   queue: queue4,
//   userId: "user3",
//   id: Uuid().v4(),
// );
// final history5 = History(
//   rest: restaurant3,
//   queue: queue5,
//   userId: "user3",
//   id: Uuid().v4(),
// );

// final List<History> mockHistories = [
//   history1,
//   history2,
//   history3,
//   history4,
//   history5,
// ];

// // Example Users
// final user1 = Customer(
//   id: "user1",
//   name: "Alice",
//   email: "alice@example.com",
//   phone: "1234567890",
//   histories: [
//     history1,
//     history2,
//     history3,
//     history3,
//     history3,
//     history3,
//     history3,
//   ],
// );

// final user2 = StoreUser(
//   id: "user2",
//   name: "Bob",
//   email: "bob@example.com",
//   phone: "0987654321",
//   rest: mockRestaurants[0],
// );

// // For admin later
// // final user3 = User(
// //   id: "user3",
// //   name: "Charlie",
// //   email: "charlie@example.com",
// //   phone: "1122334455",
// //   userType: UserType.normal,
// //   currentHistory: history4,
// //   histories: [history4, history5],
// // );

// // List of all users
// final List<User> mockUsers = [user1, user2];
