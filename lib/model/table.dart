import 'package:uuid/uuid.dart';

final uuid = Uuid();

class QueueTable {
  final String id;
  final String tableNum;
  final int seat;
  bool isTableStatus;

  QueueTable({
    String? tableId,
    required this.tableNum,
    required this.seat,
    required this.isTableStatus,
  }) : id = tableId ?? uuid.v4();

  // Copy method for creating updated instances
  QueueTable copyWith({String? tableNum, int? seat, bool? isTableStatus}) {
    return QueueTable(
      tableId: this.id,
      tableNum: tableNum ?? this.tableNum,
      seat: seat ?? this.seat,
      isTableStatus: isTableStatus ?? this.isTableStatus,
    );
  }
}
