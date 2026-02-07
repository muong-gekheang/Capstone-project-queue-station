import '../user/user.dart';
import 'table_category.dart';

enum TableStatus { available, occupied }

class QueueTable {
  final List<User> customers;
  final String tableNum;
  final int seatSize;
  final TableStatus tableStatus;
  final TableCategory category;

  const QueueTable({
    required this.customers,
    required this.tableNum,
    required this.seatSize,
    required this.tableStatus,
    required this.category,
  });
}
