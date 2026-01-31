import 'package:queue_station_app/model/table_category.dart';
import 'package:queue_station_app/model/table.dart';

List<TableCategory> tableData = [
  TableCategory(
    type: "VIP Room",
    tables: [
      QueueTable(tableNum: "V1", seat: 8, isTableStatus: true),
      QueueTable(tableNum: "V2", seat: 10, isTableStatus: false),
      QueueTable(tableNum: "V3", seat: 6, isTableStatus: true),
      QueueTable(tableNum: "V4", seat: 4, isTableStatus: true),
      QueueTable(tableNum: "V5", seat: 2, isTableStatus: false),
      QueueTable(tableNum: "V6", seat: 1, isTableStatus: true),
    ],
  ),
  TableCategory(
    type: "Indoor Standard",
    tables: [
      QueueTable(tableNum: "A1", seat: 4, isTableStatus: true),
      QueueTable(tableNum: "A2", seat: 2, isTableStatus: true),
      QueueTable(tableNum: "A3", seat: 4, isTableStatus: false),
      QueueTable(tableNum: "A4", seat: 6, isTableStatus: true),
    ],
  ),
  TableCategory(
    type: "Terrace / Outdoor",
    tables: [
      QueueTable(tableNum: "T1", seat: 2, isTableStatus: false),
      QueueTable(tableNum: "T2", seat: 2, isTableStatus: false),
      QueueTable(tableNum: "T3", seat: 4, isTableStatus: true),
    ],
  ),
];
