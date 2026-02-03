import 'package:queue_station_app/model/analytics_data.dart';
import 'package:queue_station_app/model/dashboard_stats.dart';
import 'package:queue_station_app/model/order.dart';
import 'package:queue_station_app/model/order_summary.dart';
import 'package:queue_station_app/model/queue_entry.dart';
import 'package:queue_station_app/model/store_order.dart';
import 'package:queue_station_app/model/table.dart';

class QueueRepository {
  // In-memory storage using Maps for fast lookup
  final Map<String, QueueEntry> _queueEntriesById = {};
  final Map<String, Table> _tablesById = {};
  final Map<String, StoreOrder> _ordersById = {};

  QueueRepository() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();

    // Queue entries
    final queueEntries = [
      QueueEntry(
        id: '1',
        customerName: 'John Doe',
        customerPhone: '012345678',
        partySize: 2,
        joinTime: now.subtract(const Duration(minutes: 20)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '2',
        customerName: 'Jane Smith',
        customerPhone: '012345679',
        partySize: 4,
        joinTime: now.subtract(const Duration(minutes: 15)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '3',
        customerName: 'Bob Johnson',
        customerPhone: '012345680',
        partySize: 3,
        joinTime: now.subtract(const Duration(minutes: 12)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '4',
        customerName: 'Alice Brown',
        customerPhone: '012345681',
        partySize: 2,
        joinTime: now.subtract(const Duration(minutes: 10)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '5',
        customerName: 'Charlie Wilson',
        customerPhone: '012345682',
        partySize: 5,
        joinTime: now.subtract(const Duration(minutes: 8)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '6',
        customerName: 'Diana Lee',
        customerPhone: '012345683',
        partySize: 2,
        joinTime: now.subtract(const Duration(minutes: 5)),
        status: 'waiting',
      ),
      QueueEntry(
        id: '7',
        customerName: 'Frank Miller',
        customerPhone: '012345684',
        partySize: 4,
        joinTime: now.subtract(const Duration(minutes: 3)),
        status: 'waiting',
      ),
    ];

    for (var entry in queueEntries) {
      _queueEntriesById[entry.id] = entry;
    }

    // Tables
    final tables = [
      Table(
        id: 't1',
        tableNumber: '1',
        capacity: 2,
        status: 'occupied',
        currentQueueEntryId: '1',
        occupiedSince: now.subtract(const Duration(minutes: 20)),
      ),
      Table(
        id: 't2',
        tableNumber: '2',
        capacity: 4,
        status: 'occupied',
        currentQueueEntryId: '2',
        occupiedSince: now.subtract(const Duration(minutes: 15)),
      ),
      Table(
        id: 't3',
        tableNumber: '3',
        capacity: 4,
        status: 'occupied',
        currentQueueEntryId: '3',
        occupiedSince: now.subtract(const Duration(minutes: 12)),
      ),
      Table(
        id: 't4',
        tableNumber: '4',
        capacity: 2,
        status: 'occupied',
        currentQueueEntryId: '4',
        occupiedSince: now.subtract(const Duration(minutes: 10)),
      ),
      Table(
        id: 't5',
        tableNumber: '5',
        capacity: 6,
        status: 'occupied',
        currentQueueEntryId: '5',
        occupiedSince: now.subtract(const Duration(minutes: 8)),
      ),
      Table(
        id: 't6',
        tableNumber: '6',
        capacity: 2,
        status: 'occupied',
        currentQueueEntryId: '6',
        occupiedSince: now.subtract(const Duration(minutes: 5)),
      ),
      Table(
        id: 't7',
        tableNumber: '7',
        capacity: 4,
        status: 'occupied',
        currentQueueEntryId: '7',
        occupiedSince: now.subtract(const Duration(minutes: 3)),
      ),
      Table(id: 't8', tableNumber: '8', capacity: 4, status: 'available'),
      Table(id: 't9', tableNumber: '9', capacity: 2, status: 'available'),
      Table(
        id: 't10',
        tableNumber: '10',
        capacity: 4,
        status: 'occupied',
        currentQueueEntryId: null,
        occupiedSince: now.subtract(const Duration(minutes: 25)),
      ),
    ];

    for (var table in tables) {
      _tablesById[table.id] = table;
    }

    // Orders
    final orders = [
      StoreOrder(
        id: 'o1',
        tableNumber: '1',
        totalAmount: 45.50,
        orderTime: now.subtract(const Duration(hours: 2)),
        status: 'completed',
      ),
      StoreOrder(
        id: 'o2',
        tableNumber: '2',
        totalAmount: 78.00,
        orderTime: now.subtract(const Duration(hours: 1)),
        status: 'completed',
      ),
      StoreOrder(
        id: 'o3',
        tableNumber: '3',
        totalAmount: 32.25,
        orderTime: now.subtract(const Duration(minutes: 30)),
        status: 'completed',
      ),
    ];

    for (var order in orders) {
      _ordersById[order.id] = order;
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
        .where((e) => e.status == 'waiting')
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
    // Also remove references from tables
    for (var table in _tablesById.values) {
      if (table.currentQueueEntryId == id) {
        // Table.currentQueueEntryId must not be final for this assignment to work
        table = Table(
          id: table.id,
          tableNumber: table.tableNumber,
          capacity: table.capacity,
          status: 'available',
          currentQueueEntryId: null,
          occupiedSince: table.occupiedSince,
        );
        _tablesById[table.id] = table;
      }
    }
  }

  // ================= Table Methods =================
  Future<List<Table>> getAllTables() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesById.values.toList();
  }

  Future<List<Table>> getActiveTables() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesById.values.where((t) => t.status == 'occupied').toList();
  }

  Future<Table?> getTableById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tablesById[id];
  }

  Future<void> updateTable(Table table) async {
    if (!_tablesById.containsKey(table.id)) {
      throw Exception('Table with id ${table.id} does not exist.');
    }
    _tablesById[table.id] = table;
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
  Future<List<StoreOrder>> getAllOrders() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.values.toList();
  }

  Future<List<StoreOrder>> getOrdersByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.values
        .where(
          (order) =>
              order.orderTime.isAfter(start) && order.orderTime.isBefore(end),
        )
        .toList();
  }

  Future<void> addOrder(StoreOrder order) async {
    if (_ordersById.containsKey(order.id)) {
      throw Exception('Order with id ${order.id} already exists.');
    }
    _ordersById[order.id] = order;
  }

  // ================= Analytics =================
  Future<List<QueueLengthDataPoint>> getQueueLengthData(
    String timeframe,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final now = DateTime.now();
    final List<QueueLengthDataPoint> dataPoints = [];

    // Example: queue length based on current waiting entries (simplified)
    if (timeframe == 'Today') {
      for (int hour = 8; hour <= 19; hour++) {
        final time = DateTime(now.year, now.month, now.day, hour);
        final count = _queueEntriesById.values
            .where((e) => e.joinTime.hour <= hour && e.status == 'waiting')
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
    final activeCount = _tablesById.values
        .where((t) => t.status == 'occupied')
        .length;
    final totalCount = _tablesById.length;
    return [
      TableOccupancyDataPoint(
        day: timeframe,
        occupancyPercentage: ((activeCount / totalCount) * 100),
      ),
    ];
  }

  Future<List<OrderValueDataPoint>> getAverageOrderValueData(
    String timeframe,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (_ordersById.isEmpty) return [];
    final average =
        _ordersById.values
            .map((o) => o.totalAmount)
            .fold(0.0, (a, b) => a + b) /
        _ordersById.length;
    return [OrderValueDataPoint(day: timeframe, averageOrderValue: average)];
  }

  Future<int> getTotalOrdersCount() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.length;
  }

  Future<List<OrderSummary>> getOrderSummary(String timeframe) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _ordersById.values.map((order) {
      return OrderSummary(
        order.id,
        int.parse(order.tableNumber),
        time: order.orderTime.toIso8601String(),
        tableNumber: order.tableNumber,
        amount: order.totalAmount,
        id: '',
      );
    }).toList();
  }
}
