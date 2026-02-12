import '../user/user.dart';
import 'table_category.dart';
import 'package:uuid/uuid.dart';

import '../user/user.dart';

final uuid = Uuid();

enum TableStatus { available, occupied }

class QueueTable {
  final String id;
  final List<User> customers;
  final String tableNum;
  TableStatus tableStatus;
  final TableCategory tableCategory;

  QueueTable({
    String? tableId,
    required this.tableNum,
    required this.tableStatus,
    List<User>? consumers,
    required this.tableCategory,
  }) : id = tableId ?? uuid.v4(),
       customers = consumers ?? [];

  // Copy method for creating updated instances
  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    TableCategory? tableCategory,
    List<User>? consumers, // Added this to the parameters
  }) {
    return QueueTable(
      tableId: id, // Always keep the same ID
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategory: tableCategory ?? this.tableCategory,
      consumers:
          consumers ?? this.customers, // Pass existing customers if not updated
    );
  }
}
