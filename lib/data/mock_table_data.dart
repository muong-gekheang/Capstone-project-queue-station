import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

final categoryA = TableCategory(type: "Type A", minSeat: 1, seatAmount: 2);
final categoryB = TableCategory(type: "Type B", minSeat: 3, seatAmount: 4);
final categoryC = TableCategory(type: "Type C", minSeat: 5, seatAmount: 6);

List<QueueTable> tableData = [
  // Type A Tables
  QueueTable(
    tableNum: "A1",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A2",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A3",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A4",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A5",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "A6",
    tableStatus: TableStatus.available,
    tableCategory: categoryA,
    queueEntryIds: [],
  ),

  // Type B Tables
  QueueTable(
    tableNum: "B1",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B2",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B3",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryB,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "B4",
    tableStatus: TableStatus.available,
    tableCategory: categoryB,
    queueEntryIds: [],
  ),

  // Type C Tables
  QueueTable(
    tableNum: "T1",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryC,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "T2",
    tableStatus: TableStatus.occupied,
    tableCategory: categoryC,
    queueEntryIds: [],
  ),
  QueueTable(
    tableNum: "T3",
    tableStatus: TableStatus.available,
    tableCategory: categoryC,
    queueEntryIds: [],
  ),
];
