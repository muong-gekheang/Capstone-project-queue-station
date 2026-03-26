import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart'
    show QueueEntry, QueueStatus, JoinedMethod;

/// Example restaurant used in store-side history and ticket widgets.
final Restaurant restaurant1 = Restaurant(
  id: 'rest-1',
  name: 'Kungfu Kitchen',
  address: 'BKK St.57',
  logoLink: '',
  biggestTableSize: 10,
  phone: '012255007', subscriptionDate: DateTime.now(), openingTime: 8, closingTime: 22,);

/// Minimal mock histories used across the app.
final List<QueueEntry> mockHistories = [
  QueueEntry(
    id: 'hist-1',
    queueNumber: 'D0123',
    customerId: 'user-1',
    partySize: 4,
    joinTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
    servedTime: DateTime.now().subtract(const Duration(hours: 1)),
    endedTime: DateTime.now().subtract(const Duration(minutes: 30)),
    status: QueueStatus.completed,
    joinedMethod: JoinedMethod.remote,
    orderId: null,
    expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 15)),
    assignedTableId: '', restId: 'rest-1',
  ),
  QueueEntry(
    id: 'hist-2',
    queueNumber: 'D0124',
    customerId: 'user-2',
    partySize: 2,
    joinTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    servedTime: DateTime.now().subtract(const Duration(minutes: 50)),
    endedTime: DateTime.now().subtract(const Duration(minutes: 10)),
    status: QueueStatus.completed,
    joinedMethod: JoinedMethod.walkIn,
    orderId: null, expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 15)), assignedTableId: '', restId: 'rest-1',
  ),
];

/// Convenience map for quick lookup by history id.
final Map<String, QueueEntry> mockHistoriesById = {
  for (final history in mockHistories) history.id: history,
};

/// Helper function used throughout the UI to retrieve a queue history by id.
QueueEntry? getHistoryById(String? id) {
  if (id == null) return null;
  return mockHistoriesById[id];
}

/// Mock customers with proper history IDs.
final List<Customer> mockCustomers = [
  Customer(
    id: 'user-1',
    name: 'Mary Ann',
    email: 'mary.ann@example.com',
    phone: '011224456',
    historyIds: ['hist-1'],
    currentHistoryId: null,
  ),
  Customer(
    id: 'user-2',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '012113355',
    historyIds: ['hist-2'],
    currentHistoryId: null,
  ),
];

/// Combined list of all users (customers and store users) – used where a common list is needed.
final List<User> mockUsers = [
  ...mockCustomers,
]; // Add StoreUser instances if needed
