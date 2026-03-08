import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';

// Keep it last because we might have a prebuilt service that we can use later
class AnalyticsService {
  final QueueService _queueService;
  final RestaurantService _restaurantService;
  AnalyticsService({
    required QueueService queueService,
    required RestaurantService restaurantService,
  }) : _queueService = queueService,
       _restaurantService = restaurantService;

  Future<DashboardStats> get dashboardStats async {
    int activeTables = 0;
    for (var table in await _restaurantService.tables) {
      if (table.queueEntryIds.isNotEmpty) {
        activeTables++;
      }
    }

    return DashboardStats(
      queueEntries: _queueService.currentEntries.length,
      peopleWaiting: _queueService.peopleWaiting,
      activeTables: activeTables,
      averageWaitTimeMinutes:
          (await _restaurantService.avgWaitingTime).inMinutes,
    );
  }
}
