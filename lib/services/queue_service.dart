import '../core/models/queue_entry.dart';
import '../core/models/table.dart';
import '../core/models/dashboard_stats.dart';
import '../core/repositories/queue_repository.dart';

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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      customerPhone: customerPhone,
      partySize: partySize,
      joinTime: DateTime.now(),
      status: 'waiting',
    );

    await _repository.addQueueEntry(entry);
  }

  Future<void> serveCustomer(String queueEntryId, String tableNumber) async {
    final entry = await _repository.getQueueEntryById(queueEntryId);
    if (entry != null) {
      final updatedEntry = entry.copyWith(
        status: 'served',
        servedTime: DateTime.now(),
        tableNumber: tableNumber,
      );
      await _repository.updateQueueEntry(updatedEntry);

      // Update table status
      final tables = await _repository.getAllTables();
      final table = tables.firstWhere(
        (t) => t.tableNumber == tableNumber,
        orElse: () => tables.first,
      );
      final updatedTable = table.copyWith(
        status: 'occupied',
        currentQueueEntryId: queueEntryId,
        occupiedSince: DateTime.now(),
      );
      await _repository.updateTable(updatedTable);
    }
  }

  Future<void> cancelQueueEntry(String queueEntryId) async {
    final entry = await _repository.getQueueEntryById(queueEntryId);
    if (entry != null) {
      final updatedEntry = entry.copyWith(status: 'cancelled');
      await _repository.updateQueueEntry(updatedEntry);
    }
  }

  // Table Operations
  Future<List<Table>> getActiveTables() async {
    return await _repository.getActiveTables();
  }

  Future<List<Table>> getAllTables() async {
    return await _repository.getAllTables();
  }

  Future<void> freeTable(String tableNumber) async {
    final tables = await _repository.getAllTables();
    final table = tables.firstWhere(
      (t) => t.tableNumber == tableNumber,
    );
    final updatedTable = table.copyWith(
      status: 'available',
      currentQueueEntryId: null,
      occupiedSince: null,
    );
    await _repository.updateTable(updatedTable);
  }

  // Dashboard Stats
  Future<DashboardStats> getDashboardStats() async {
    return await _repository.getDashboardStats();
  }

  // Calculate estimated wait time for a new customer
  Future<int> calculateEstimatedWaitTime(int partySize) async {
    final stats = await getDashboardStats();
    final activeTables = await getActiveTables();
    
    // Simple estimation: average wait time + (people ahead / tables available)
    final availableTables = activeTables
        .where((table) => table.status == 'available' && table.capacity >= partySize)
        .length;
    
    if (availableTables > 0) {
      return stats.averageWaitTimeMinutes;
    } else {
      // If no available tables, estimate based on average service time
      return stats.averageWaitTimeMinutes + (stats.peopleWaiting ~/ stats.activeTables);
    }
  }
}
