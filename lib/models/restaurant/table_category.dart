import 'queue_table.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class TableCategory {
  final String id;
  final String type;
  final int seatAmount;

  TableCategory({
    String? categoryId,
    required this.type,
    required this.seatAmount,
  }) : id = categoryId ?? uuid.v4();
}
