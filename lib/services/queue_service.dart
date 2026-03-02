import 'package:queue_station_app/data/queue_repository.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class QueueService {
  final QueueRepository _repository;

  QueueService(this._repository);

  // Queue Entry Operations
  Future<List<QueueEntry>> getWaitingQueue() async {
    return await _repository.getWaitingQueueEntries();
  }

  Future<List<QueueEntry>> getAllQueueEntries() async {
    return await _repository.getAllQueueEntries();
  }

  Future<void> addCustomerToQueue({
    required String customerName,
    required String customerPhone,
    required int partySize,
  }) async {
    final entry = QueueEntry(
      queueNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      partySize: partySize,
      joinTime: DateTime.now(),
      status: QueueStatus.waiting, // This is correct - using enum
      customerId: '',
      joinedMethod: JoinedMethod.remote,
    );

    await _repository.addQueueEntry(entry);
  }

  Future<void> serveCustomer(String queueEntryId, String tableNumber) async {
    final entry = await _repository.getQueueEntryById(queueEntryId);
    if (entry != null) {
      final updatedEntry = entry.copyWith(
        status: QueueStatus.serving,
        servedTime: DateTime.now(),
        tableNumber: tableNumber,
      );
      await _repository.updateQueueEntry(updatedEntry);

      // Update table status
      final table = await _repository.getTableByNumber(tableNumber);
      if (table != null) {
        final updatedTable = table.copyWith(
          tableStatus: TableStatus.occupied,
          currentQueueEntryId: queueEntryId,
          occupiedSince: DateTime.now(),
        );
        await _repository.updateTable(updatedTable);
      }
    }
  }

  Future<void> cancelQueueEntry(String queueEntryId) async {
    final entry = await _repository.getQueueEntryById(queueEntryId);
    if (entry != null) {
      final updatedEntry = entry.copyWith(
        status: QueueStatus.cancelled, // FIXED: Using enum instead of string
        servedTime: DateTime.now(),
      );
      await _repository.updateQueueEntry(updatedEntry);
    }
  }

  // Table Operations
  Future<List<QueueTable>> getActiveTables() async {
    return await _repository.getActiveTables();
  }

  Future<List<QueueTable>> getAllTables() async {
    return await _repository.getAllTables();
  }

  Future<void> freeTable(String tableNumber) async {
    final table = await _repository.getTableByNumber(tableNumber);
    if (table != null) {
      final updatedTable = table.copyWith(
        tableStatus: TableStatus.available,
        currentQueueEntryId: null,
        occupiedSince: null,
      );
      await _repository.updateTable(updatedTable);
    }
  }

  // Dashboard Stats
  Future<DashboardStats> getDashboardStats() async {
    return await _repository.getDashboardStats();
  }

  // Calculate estimated wait time for a new customer
  Future<int> calculateEstimatedWaitTime(int partySize) async {
    final stats = await getDashboardStats();
    final allTables = await getAllTables();

    // Simple estimation: average wait time + (people ahead / tables available)
    final availableTables = allTables
        .where((table) => table.tableStatus == TableStatus.available)
        .length;

    if (availableTables > 0) {
      return stats.averageWaitTimeMinutes;
    } else {
      // If no available tables, estimate based on average service time
      return stats.averageWaitTimeMinutes +
          (stats.peopleWaiting ~/ (stats.activeTables + 1));
    }
  }
}
