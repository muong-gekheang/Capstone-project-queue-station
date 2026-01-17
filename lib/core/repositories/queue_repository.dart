import '../models/queue_entry.dart';
import '../models/table.dart';
import '../models/dashboard_stats.dart';
import '../models/order.dart';
import '../models/analytics_data.dart';

class QueueRepository {
  // In-memory storage for demo purposes
  // In production, this would connect to a database or API
  final List<QueueEntry> _queueEntries = [];
  final List<Table> _tables = [];
  final List<Order> _orders = [];

  // Initialize with sample data
  QueueRepository() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample queue entries
    final now = DateTime.now();
    _queueEntries.addAll([
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
    ]);

    // Sample tables
    _tables.addAll([
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
      Table(
        id: 't8',
        tableNumber: '8',
        capacity: 4,
        status: 'available',
      ),
      Table(
        id: 't9',
        tableNumber: '9',
        capacity: 2,
        status: 'available',
      ),
      Table(
        id: 't10',
        tableNumber: '10',
        capacity: 4,
        status: 'occupied',
        currentQueueEntryId: null,
        occupiedSince: now.subtract(const Duration(minutes: 25)),
      ),
    ]);

    // Sample orders
    _orders.addAll([
      Order(
        id: 'o1',
        tableNumber: '1',
        totalAmount: 45.50,
        orderTime: now.subtract(const Duration(hours: 2)),
        status: 'completed',
      ),
      Order(
        id: 'o2',
        tableNumber: '2',
        totalAmount: 78.00,
        orderTime: now.subtract(const Duration(hours: 1)),
        status: 'completed',
      ),
      Order(
        id: 'o3',
        tableNumber: '3',
        totalAmount: 32.25,
        orderTime: now.subtract(const Duration(minutes: 30)),
        status: 'completed',
      ),
    ]);
  }

  // Queue Entry Methods
  Future<List<QueueEntry>> getAllQueueEntries() async {
    return List.from(_queueEntries);
  }

  Future<List<QueueEntry>> getWaitingQueueEntries() async {
    return _queueEntries.where((entry) => entry.status == 'waiting').toList();
  }

  Future<QueueEntry?> getQueueEntryById(String id) async {
    try {
      return _queueEntries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addQueueEntry(QueueEntry entry) async {
    _queueEntries.add(entry);
  }

  Future<void> updateQueueEntry(QueueEntry entry) async {
    final index = _queueEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _queueEntries[index] = entry;
    }
  }

  Future<void> removeQueueEntry(String id) async {
    _queueEntries.removeWhere((entry) => entry.id == id);
  }

  // Table Methods
  Future<List<Table>> getAllTables() async {
    return List.from(_tables);
  }

  Future<List<Table>> getActiveTables() async {
    return _tables.where((table) => table.status == 'occupied').toList();
  }

  Future<Table?> getTableById(String id) async {
    try {
      return _tables.firstWhere((table) => table.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTable(Table table) async {
    final index = _tables.indexWhere((t) => t.id == table.id);
    if (index != -1) {
      _tables[index] = table;
    }
  }

  // Dashboard Stats
  Future<DashboardStats> getDashboardStats() async {
    final waitingEntries = await getWaitingQueueEntries();
    final activeTables = await getActiveTables();
    
    // Calculate total people waiting
    final peopleWaiting = waitingEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.partySize,
    );

    // Calculate average wait time for waiting entries
    final now = DateTime.now();
    int totalWaitTimeMinutes = 0;
    int count = 0;

    for (var entry in waitingEntries) {
      final waitTime = now.difference(entry.joinTime);
      totalWaitTimeMinutes += waitTime.inMinutes;
      count++;
    }

    final averageWaitTimeMinutes = count > 0
        ? (totalWaitTimeMinutes / count).round()
        : 0;

    return DashboardStats(
      queueEntries: waitingEntries.length,
      peopleWaiting: peopleWaiting,
      activeTables: activeTables.length,
      averageWaitTimeMinutes: averageWaitTimeMinutes,
    );
  }

  // Order Methods
  Future<List<Order>> getAllOrders() async {
    return List.from(_orders);
  }

  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end) async {
    return _orders.where((order) {
      return order.orderTime.isAfter(start) && order.orderTime.isBefore(end);
    }).toList();
  }

  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  // Analytics Data Methods
  Future<List<QueueLengthDataPoint>> getQueueLengthData(String timeframe) async {
    final now = DateTime.now();
    final List<QueueLengthDataPoint> dataPoints = [];

    if (timeframe == 'Today') {
      // Generate hourly data for today
      for (int hour = 8; hour <= 19; hour++) {
        final time = DateTime(now.year, now.month, now.day, hour);
        // Simulate queue length data
        int queueLength = 20;
        if (hour >= 10 && hour <= 13) queueLength = 18;
        if (hour >= 15 && hour <= 17) queueLength = 30;
        if (hour >= 17) queueLength = 22;
        
        dataPoints.add(QueueLengthDataPoint(time: time, queueLength: queueLength));
      }
    }

    return dataPoints;
  }

  Future<List<TableOccupancyDataPoint>> getTableOccupancyData(String timeframe) async {
    if (timeframe == 'This Week') {
      return [
        TableOccupancyDataPoint(day: 'Monday', occupancyPercentage: 65),
        TableOccupancyDataPoint(day: 'Wednesday', occupancyPercentage: 55),
        TableOccupancyDataPoint(day: 'Friday', occupancyPercentage: 60),
        TableOccupancyDataPoint(day: 'Sunday', occupancyPercentage: 80),
      ];
    }
    return [];
  }

  Future<List<OrderValueDataPoint>> getAverageOrderValueData(String timeframe) async {
    if (timeframe == 'This Week') {
      return [
        OrderValueDataPoint(day: 'Monday', averageOrderValue: 320),
        OrderValueDataPoint(day: 'Wednesday', averageOrderValue: 280),
        OrderValueDataPoint(day: 'Friday', averageOrderValue: 320),
        OrderValueDataPoint(day: 'Sunday', averageOrderValue: 450),
      ];
    }
    return [];
  }

  Future<List<OrdersDataPoint>> getOrdersData(String timeframe) async {
    final now = DateTime.now();
    final List<OrdersDataPoint> dataPoints = [];

    if (timeframe == 'Today') {
      // Generate hourly data for today
      for (int hour = 8; hour <= 19; hour++) {
        final time = DateTime(now.year, now.month, now.day, hour);
        // Simulate order count data
        int orderCount = 10;
        if (hour == 10) orderCount = 20;
        if (hour >= 13 && hour <= 15) orderCount = 18;
        if (hour >= 15 && hour <= 17) orderCount = 30;
        if (hour >= 17) orderCount = 23;
        
        dataPoints.add(OrdersDataPoint(time: time, orderCount: orderCount));
      }
    }

    return dataPoints;
  }

  Future<int> getTotalOrdersCount() async {
    // For demo purposes, return a realistic count
    // In production, this would count actual orders
    return 120;
  }
}
