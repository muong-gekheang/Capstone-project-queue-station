import 'package:queue_station_app/models/analytic/analytics_data.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';

class AnalyticsService {
  final QueueService _queueService;
  final TableService _tableService;
  final OrderService _orderService;
  AnalyticsService({
    required QueueService queueService,
    required TableService tableService,
    required OrderService orderService,
  }) : _queueService = queueService,
       _tableService = tableService,
       _orderService = orderService;

  Future<DashboardStats> get dashboardStats async {
    int activeTables = 0;
    for (var table in _tableService.tables) {
      if (table.queueEntryIds.isNotEmpty) {
        activeTables++;
      }
    }

    return DashboardStats(
      queueEntries: _queueService.currentEntries.length,
      peopleWaiting: _queueService.peopleWaiting,
      activeTables: activeTables,
      totalOrders: _orderService.todayOrder.length,
      averageWaitTimeMinutes: (await _queueService.avgWaitingTime).inMinutes,
    );
  }

  int get todayTotalOrders {
    return _orderService.todayOrder.length;
  }

  List<QueueLengthDataPoint> getQueueLengthData(TimeFrameOption option) {
    final Map<DateTime, int> buckets = {};

    for (var entry in _queueService.queueHistory) {
      final bucketTime = _roundToBucket(entry.joinTime, option.bucketSize);

      buckets[bucketTime] = (buckets[bucketTime] ?? 0) + 1;
    }

    return buckets.entries
        .map((e) => QueueLengthDataPoint(time: e.key, queueLength: e.value))
        .toList();
  }

  List<TableOccupancyDataPoint> getTableOccupancyData(TimeFrameOption option) {
    final Map<DateTime, int> buckets = {};

    for (var entry in _queueService.queueHistory) {
      // This is the magic line: it rounds the time down to your bucket size
      final bucketTime = _roundToBucket(entry.joinTime, option.bucketSize);

      buckets[bucketTime] = (buckets[bucketTime] ?? 0) + 1;
    }

    return buckets.entries
        .map((e) => TableOccupancyDataPoint(day: e.key, occupancyPercentage: 1))
        .toList();
  }

  DateTime _roundToBucket(DateTime time, Duration duration) {
    return DateTime.fromMillisecondsSinceEpoch(
      (time.millisecondsSinceEpoch / duration.inMilliseconds).floor() *
          duration.inMilliseconds,
    );
  }
}
