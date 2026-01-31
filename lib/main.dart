import 'package:flutter/material.dart';
import 'package:queue_station_app/data/mock_table_data.dart';
import 'package:queue_station_app/model/table_category.dart';
import 'package:queue_station_app/ui/screen/table_management_screen.dart';

void main() {
  // runApp(const QueueStationApp());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QueueStationApp(mockTableData: tableData),
      // home: Scaffold(body: MapScreen()),
    ),
  );
}

// class QueueStationApp extends StatelessWidget {
//   const QueueStationApp({super.key});
// }

class QueueStationApp extends StatelessWidget {
  const QueueStationApp({super.key, required this.mockTableData});

  final List<TableCategory> mockTableData;

  @override
  Widget build(BuildContext context) {
    return TableManagementScreen(tableCategory: mockTableData);

    // return Scaffold(
    //   appBar: AppBar(title: Text("Table Management")),
    //   body: TableManagementScreen(),
    // );
  }
}
