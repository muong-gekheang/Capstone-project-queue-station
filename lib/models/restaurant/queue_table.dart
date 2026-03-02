import '../user/abstracts/user.dart';
import 'table_category.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

enum TableStatus { available, occupied }

class QueueTable {
  final String id;
  final String tableNum;
  TableStatus tableStatus;
  final TableCategory tableCategory;
  final List<User> customers;
  final String? currentQueueEntryId;
  final DateTime? occupiedSince;

  QueueTable({
    String? id,
    required this.tableNum,
    required this.tableStatus,
    required this.tableCategory,
    List<User>? customers,
    this.currentQueueEntryId,
    this.occupiedSince,
  }) : id = id ?? uuid.v4(),
       customers = customers ?? [];

  // Copy method with ALL fields
  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    TableCategory? tableCategory,
    List<User>? customers,
    String? currentQueueEntryId,
    DateTime? occupiedSince,
  }) {
    return QueueTable(
      id: id, // Keep same ID
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategory: tableCategory ?? this.tableCategory,
      customers: customers ?? this.customers,
      currentQueueEntryId: currentQueueEntryId ?? this.currentQueueEntryId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
    );
  }
}
