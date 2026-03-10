import 'package:queue_station_app/models/analytic/analytics_data.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';

// Keep it last because we might have a prebuilt service that we can use later
class AnalyticsService {
  final QueueService _queueService;
  final TableService _tableService;
  AnalyticsService({
    required QueueService queueService,
    required TableService tableService,
  }) : _queueService = queueService,
       _tableService = tableService;

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
      averageWaitTimeMinutes: (await _queueService.avgWaitingTime).inMinutes,
    );
  }

  int get totalOrders {
    return 100; // TODO: Implement Order Service
  }

  List<QueueLengthDataPoint> getGraphData(
    List<QueueEntry> rawHistory,
    TimeFrameOption option,
  ) {
    final Map<DateTime, int> buckets = {};

    for (var entry in rawHistory) {
      // This is the magic line: it rounds the time down to your bucket size
      final bucketTime = _roundToBucket(entry.joinTime, option.bucketSize);

      buckets[bucketTime] = (buckets[bucketTime] ?? 0) + 1;
    }

    return buckets.entries
        .map((e) => QueueLengthDataPoint(time: e.key, queueLength: e.value))
        .toList();
  }

  DateTime _roundToBucket(DateTime time, Duration duration) {
    return DateTime.fromMillisecondsSinceEpoch(
      (time.millisecondsSinceEpoch / duration.inMilliseconds).floor() *
          duration.inMilliseconds,
    );
  }
}
