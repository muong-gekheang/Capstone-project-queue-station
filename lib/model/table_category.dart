import 'table.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class TableCategory {
  final String id;
  final String type;
  final List<QueueTable> tables;

  TableCategory({String? categoryId, required this.type, required this.tables})
    : id = categoryId ?? uuid.v4();

  int get numofTable => tables.length;
}
