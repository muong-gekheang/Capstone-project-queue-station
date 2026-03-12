import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository_mock.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository_mock.dart';
import 'package:queue_station_app/models/analytic/analytics_data.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class QueueRepository {
  final Map<String, QueueEntry> _queueEntriesById = {};
  final Map<String, QueueTable> _tablesByNumber = {};
  final Map<String, dynamic> _ordersById = {};

  QueueRepository() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final queueEntries = [
      QueueEntry(
        id: '101',
        partySize: 4,
        joinTime: DateTime.now().subtract(const Duration(minutes: 45)),
        status: QueueStatus.waiting,
        queueNumber: 'A-001',
        customerId: 'user_789',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '102',
        partySize: 2,
        joinTime: DateTime.now().subtract(const Duration(minutes: 32)),
        status: QueueStatus.waiting,
        queueNumber: 'B-012',
        customerId: 'user_456',
        joinedMethod: JoinedMethod.walkIn,
        restId: mockRestaurants[1].id,
      ),
      QueueEntry(
        id: '103',
        partySize: 1,
        joinTime: DateTime.now().subtract(const Duration(minutes: 28)),
        status: QueueStatus.noShow,
        queueNumber: 'S-005',
        customerId: 'user_112',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[3].id,
      ),
      QueueEntry(
        id: '104',
        partySize: 6,
        joinTime: DateTime.now().subtract(const Duration(minutes: 25)),
        status: QueueStatus.waiting,
        queueNumber: 'L-002',
        customerId: 'user_990',
        joinedMethod: JoinedMethod.walkIn,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '105',
        partySize: 2,
        joinTime: DateTime.now().subtract(const Duration(minutes: 18)),
        status: QueueStatus.waiting,
        queueNumber: 'B-013',
        customerId: 'user_334',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '106',
        partySize: 3,
        joinTime: DateTime.now().subtract(const Duration(minutes: 15)),
        status: QueueStatus.waiting,
        queueNumber: 'C-021',
        customerId: 'user_221',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '107',
        partySize: 2,
        joinTime: DateTime.now().subtract(const Duration(minutes: 10)),
        status: QueueStatus.waiting,
        queueNumber: 'B-014',
        customerId: 'user_554',
        joinedMethod: JoinedMethod.walkIn,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '108',
        partySize: 8,
        joinTime: DateTime.now().subtract(const Duration(minutes: 8)),
        status: QueueStatus.waiting,
        queueNumber: 'XL-001',
        customerId: 'user_667',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '109',
        partySize: 2,
        joinTime: DateTime.now().subtract(const Duration(minutes: 5)),
        status: QueueStatus.waiting,
        queueNumber: 'B-015',
        customerId: 'user_882',
        joinedMethod: JoinedMethod.remote,
        restId: mockRestaurants[0].id,
      ),
      QueueEntry(
        id: '110',
        partySize: 4,
        joinTime: DateTime.now().subtract(const Duration(minutes: 2)),
        status: QueueStatus.waiting,
        queueNumber: 'A-002',
        customerId: 'user_003',
        joinedMethod: JoinedMethod.walkIn,
        restId: mockRestaurants[0].id,
      ),
    ];

    for (var entry in queueEntries) {
      _queueEntriesById[entry.id] = entry;
    }

    final tables = mockTables;
    for (var table in tables) {
      _tablesByNumber[table.tableNum] = table;
    }
  }

  // ================= Queue Methods =================
  Future<List<QueueEntry>> getAllQueueEntries() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _queueEntriesById.values.toList();
  }

  Future<List<QueueEntry>> getWaitingQueueEntries() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _queueEntriesById.values
        .where((e) => e.status == QueueStatus.waiting)
        .toList();
  }

  Future<QueueEntry?> getQueueEntryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _queueEntriesById[id];
  }

  Future<void> addQueueEntry(QueueEntry entry) async {
    if (_queueEntriesById.containsKey(entry.id)) {
      throw Exception('QueueEntry with id ${entry.id} already exists.');
    }
    _queueEntriesById[entry.id] = entry;
  }

  Future<void> updateQueueEntry(QueueEntry entry) async {
    if (!_queueEntriesById.containsKey(entry.id)) {
      throw Exception('QueueEntry with id ${entry.id} does not exist.');
    }
    _queueEntriesById[entry.id] = entry;
  }

  Future<void> removeQueueEntry(String id) async {
    _queueEntriesById.remove(id);
    for (var table in _tablesByNumber.values) {
      if (table.queueEntryIds.contains(id)) {
        final updatedQueueIds = [...table.queueEntryIds]..remove(id);
        final updatedTable = table.copyWith(
          tableStatus: updatedQueueIds.isEmpty
              ? TableStatus.available
              : TableStatus.occupied,
          queueEntryIds: updatedQueueIds,
        );
        _tablesByNumber[updatedTable.tableNum] = updatedTable;
      }
    }
  }

  // ================= Table Methods =================
  Future<List<QueueTable>> getAllTables() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesByNumber.values.toList();
  }

  Future<List<QueueTable>> getActiveTables() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesByNumber.values
        .where((t) => t.tableStatus == TableStatus.occupied)
        .toList();
  }

  Future<QueueTable?> getTableByNumber(String tableNum) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesByNumber[tableNum];
  }

  Future<void> updateTable(QueueTable table) async {
    if (!_tablesByNumber.containsKey(table.tableNum)) {
      throw Exception('Table with number ${table.tableNum} does not exist.');
    }
    _tablesByNumber[table.tableNum] = table;
  }

  // ================= Dashboard Stats =================
  Future<DashboardStats> getDashboardStats() async {
    final waitingEntries = await getWaitingQueueEntries();
    final activeTables = await getActiveTables();
    final now = DateTime.now();

    final peopleWaiting = waitingEntries.fold<int>(
      0,
      (sum, e) => sum + e.partySize,
    );

    final totalWaitTime = waitingEntries
        .map((e) => now.difference(e.joinTime).inMinutes)
        .fold(0, (a, b) => a + b);

    final averageWaitTimeMinutes = waitingEntries.isNotEmpty
        ? (totalWaitTime ~/ waitingEntries.length)
        : 0;

    return DashboardStats(
      queueEntries: waitingEntries.length,
      peopleWaiting: peopleWaiting,
      activeTables: activeTables.length,
      averageWaitTimeMinutes: averageWaitTimeMinutes,
    );
  }

  // ================= Orders =================
  Future<List<dynamic>> getAllOrders() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.values.toList();
  }

  Future<int> getTotalOrdersCount() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.length;
  }

  // ================= Analytics =================
  Future<List<QueueLengthDataPoint>> getQueueLengthData(
    String timeframe,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final now = DateTime.now();
    final List<QueueLengthDataPoint> dataPoints = [];

    if (timeframe == 'Today') {
      for (int hour = 8; hour <= 19; hour++) {
        final time = DateTime(now.year, now.month, now.day, hour);
        final count = _queueEntriesById.values
            .where(
              (e) => e.joinTime.hour <= hour && e.status == QueueStatus.waiting,
            )
            .length;
        dataPoints.add(QueueLengthDataPoint(time: time, queueLength: count));
      }
    }

    return dataPoints;
  }

  Future<List<TableOccupancyDataPoint>> getTableOccupancyData(
    String timeframe,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final activeCount = _tablesByNumber.values
        .where((t) => t.tableStatus == TableStatus.occupied)
        .length;
    final totalCount = _tablesByNumber.length;
    return [
      TableOccupancyDataPoint(
        day: timeframe,
        occupancyPercentage: totalCount > 0
            ? ((activeCount / totalCount) * 100)
            : 0,
      ),
    ];
  }

  Future<dynamic> getAverageOrderValueData(String orderValueTimeframe) async {}
  Future<dynamic> getOrderSummary(String ordersTimeframe) async {}
}
