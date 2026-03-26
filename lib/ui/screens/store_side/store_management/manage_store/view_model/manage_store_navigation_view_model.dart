import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/analytics_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/analytics_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management/table_management_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/menu_management_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/store_queue_history_screen.dart';

/// ViewModel that handles all navigation and provider setup for ManageStore screens
class ManageStoreNavigationViewModel {
  final BuildContext context;

  ManageStoreNavigationViewModel({required this.context});

  /// Navigate to table management with required providers
  void navigateToTableManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newScreenContext) => MultiProvider(
          providers: [
            Provider.value(value: context.read<TableService>()),
            Provider.value(value: context.read<QueueService>()),
            Provider.value(value: context.read<OrderService>()),
          ],
          child: const TableManagementScreen(),
        ),
      ),
    );
  }

  /// Navigate to menu management with required providers
  void navigateToMenuManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newScreenContext) => Provider.value(
          value: context.read<MenuService>(),
          child: const MenuManagementScreen(),
        ),
      ),
    );
  }

  /// Navigate to queue history with required providers
  void navigateToQueueHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newScreenContext) => MultiProvider(
          providers: [
            Provider.value(value: context.read<QueueService>()),
            Provider.value(value: context.read<OrderService>()),
          ],
          child: const StoreQueueHistoryScreen(),
        ),
      ),
    );
  }

  /// Navigate to analytics with required providers
  void navigateToAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider.value(value: context.read<AnalyticsService>()),
            Provider.value(value: context.read<RestaurantService>()),
          ],
          child: const AnalyticsScreen(),
        ),
      ),
    );
  }
}
