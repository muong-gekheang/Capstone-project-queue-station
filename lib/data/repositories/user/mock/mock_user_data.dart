import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

// --- 5 CUSTOMERS (with hardcoded IDs matching those in queue entries) ---
List<Customer> mockCustomers = [
  Customer(
    id: 'cust-1', // matches queueEntry above
    name: "Sok Dara",
    email: "dara.sok@gmail.com",
    phone: "012888777",
    historyIds: ['hist-1'], // hardcoded history ID
  ),
  Customer(
    id: 'cust-2',
    name: "Chan Bopha",
    email: "bopha.chan@outlook.com",
    phone: "015222333",
    historyIds: [], // New user, no history yet
  ),
  Customer(
    id: 'cust-3',
    name: "Keo Pich",
    email: "pich.keo@yahoo.com",
    phone: "099444555",
    historyIds: ['hist-2'],
  ),
  Customer(
    id: uuid.v4(),
    name: "Vannak Nimol",
    email: "nimol.v@gmail.com",
    phone: "088777666",
    historyIds: [],
  ),
  Customer(
    id: uuid.v4(),
    name: "Rithy Sak",
    email: "sak.rithy@cadt.edu.kh",
    phone: "011999000",
    historyIds: [],
  ),
];

// --- 5 STORE USERS (without storeName/storeAddress) ---
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

// Combined list
List<User> mockUsers = [...mockCustomers, ...mockStoreUsers];
