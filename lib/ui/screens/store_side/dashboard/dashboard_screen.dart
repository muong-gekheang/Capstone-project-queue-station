import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/dashboard/view_model/dashboard_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/dashboard/widgets/dashboard_content.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantService restaurantState = context.read<RestaurantService>();
    QueueService queueService = context.read<QueueService>();
    TableService tableService = context.read<TableService>();
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        restaurantService: restaurantState,
        queueService: queueService,
        tableService: tableService,
      ),
      child: DashboardContent(),
    );
  }
}
