import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

final categoryA = TableCategory(type: "Type A", seatAmount: 2);
final categoryB = TableCategory(type: "Type B", seatAmount: 4);
final categoryC = TableCategory(type: "Type C", seatAmount: 6);

List<QueueTable> tableData = [
  // Type A Tables
  QueueTable(
    tableNum: "A1",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
  ),
  QueueTable(
    tableNum: "A2",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryA,
  ),
  QueueTable(
    tableNum: "A3",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
  ),
  QueueTable(
    tableNum: "A4",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
  ),
  QueueTable(
    tableNum: "A5",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryA,
  ),
  QueueTable(
    tableNum: "A6",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
  ),

  // Type B Tables
  QueueTable(
    tableNum: "B1",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
  ),
  QueueTable(
    tableNum: "B2",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
  ),
  QueueTable(
    tableNum: "B3",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryB,
  ),
  QueueTable(
    tableNum: "B4",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
  ),

  // Type C Tables
  QueueTable(
    tableNum: "T1",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryC,
  ),
  QueueTable(
    tableNum: "T2",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryC,
  ),
  QueueTable(
    tableNum: "T3",
    tableStatus: TableStatus.available,
    tableCategory: categoryC,
  ),
];
