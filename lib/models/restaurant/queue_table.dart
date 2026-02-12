import 'package:uuid/uuid.dart';

import '../user/user.dart';

final uuid = Uuid();

enum TableStatus { available, occupied }

class QueueTable {
  final String id;
  final List<User> customers;
  final String tableNum;
  TableStatus tableStatus;

  QueueTable({
    String? tableId,
    required this.tableNum,
    required this.tableStatus,
    List<User>? consumers,
  }) : id = tableId ?? uuid.v4(),
       customers = consumers ?? [];

  // Copy method for creating updated instances
  QueueTable copyWith({String? tableNum, int? seat, TableStatus? tableStatus}) {
    return QueueTable(
      tableId: id,
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
    );
  }
}
