import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';

List<TableCategory> tableData = [
  TableCategory(
    type: "Type A",
    seatAmount: 2,
    tables: [
      QueueTable(tableNum: "A1", tableStatus: TableStatus.available),
      QueueTable(tableNum: "A2", tableStatus: TableStatus.occupied),
      QueueTable(tableNum: "A3", tableStatus: TableStatus.available),
      QueueTable(tableNum: "A4", tableStatus: TableStatus.available),
      QueueTable(tableNum: "A5", tableStatus: TableStatus.occupied),
      QueueTable(tableNum: "A6", tableStatus: TableStatus.available),
    ],
  ),
  TableCategory(
    type: "Type B",
    seatAmount: 4,
    tables: [
      QueueTable(tableNum: "A1", tableStatus: TableStatus.available),
      QueueTable(tableNum: "A2", tableStatus: TableStatus.available),
      QueueTable(tableNum: "A3", tableStatus: TableStatus.occupied),
      QueueTable(tableNum: "A4", tableStatus: TableStatus.available),
    ],
  ),
  TableCategory(
    type: "Type C",
    seatAmount: 6,
    tables: [
      QueueTable(tableNum: "T1", tableStatus: TableStatus.occupied),
      QueueTable(tableNum: "T2", tableStatus: TableStatus.occupied),
      QueueTable(tableNum: "T3", tableStatus: TableStatus.available),
    ],
  ),
];
