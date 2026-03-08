import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management/view_model/table_management_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management/widgets/table_management_content.dart';

class TableManagementScreen extends StatelessWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TableService tableService = context.read<TableService>();
    return ChangeNotifierProvider(
      create: (_) => TableManagementViewModel(tableService: tableService),
      child: TableManagementContent(),
    );
  }
}
