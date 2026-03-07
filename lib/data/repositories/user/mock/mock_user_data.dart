import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_mock.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid();

// --- 5 CUSTOMERS ---
List<Customer> mockCustomers = [
  Customer(
    id: uuid.v4(),
    name: "Sok Dara",
    email: "dara.sok@gmail.com",
    phone: "012888777",
    historyIds: mockQueueEntries
        .where(
          (q) =>
              q.status == QueueStatus.completed ||
              q.status == QueueStatus.cancelled,
        )
        .map((q) => q.id)
        .take(3)
        .toList(),
  ),
  Customer(
    id: uuid.v4(),
    name: "Chan Bopha",
    email: "bopha.chan@outlook.com",
    phone: "015222333",
    historyIds: [], // New user, no history yet
  ),
  Customer(
    id: uuid.v4(),
    name: "Keo Pich",
    email: "pich.keo@yahoo.com",
    phone: "099444555",
    historyIds: [mockQueueEntries.first.id],
  ),
  Customer(
    id: uuid.v4(),
    name: "Vannak Nimol",
    email: "nimol.v@gmail.com",
    phone: "088777666",
    historyIds: mockQueueEntries.map((q) => q.id).toList(),
  ),
  Customer(
    id: uuid.v4(),
    name: "Rithy Sak",
    email: "sak.rithy@cadt.edu.kh",
    phone: "011999000",
    historyIds: [],
  ),
];

// --- 5 STORE USERS ---
List<StoreUser> mockStoreUsers = [
  StoreUser(
    id: uuid.v4(),
    name: "Manager Rath",
    email: "rath.manager@queuestation.com",
    phone: "012333444",
  ),
  StoreUser(
    id: uuid.v4(),
    name: "Srey Leak",
    email: "sreyleak.staff@queuestation.com",
    phone: "010555666",
  ),
  StoreUser(
    id: uuid.v4(),
    name: "Kosal Vichea",
    email: "vichea.admin@queuestation.com",
    phone: "077111222",
  ),
  StoreUser(
    id: uuid.v4(),
    name: "Mony Reach",
    email: "reach.m@queuestation.com",
    phone: "012666777",
  ),
  StoreUser(
    id: uuid.v4(),
    name: "Thyda Som",
    email: "thyda.s@queuestation.com",
    phone: "016888999",
  ),
];

// Combine them into your global mockUsers list if needed
List<User> mockUsers = [...mockCustomers, ...mockStoreUsers];
