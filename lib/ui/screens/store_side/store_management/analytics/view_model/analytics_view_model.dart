import 'dart:async'; // For Timer

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/analytic/analytics_data.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/models/analytic/order_summary.dart';
import 'package:queue_station_app/services/store/analytics_service.dart';

enum TimeFrameOption {
  today("Today", Duration(minutes: 15)),
  thisWeek("This Week", Duration(hours: 6)),
  thisMonth("This Month", Duration(days: 1)),
  thisYear("This Year", Duration(days: 31));

  final String label;
  final Duration bucketSize;

  const TimeFrameOption(this.label, this.bucketSize);
}

class AnalyticsViewModel extends ChangeNotifier {
  final AnalyticsService _analyticsService;
  Timer? _refreshTimer;

  AnalyticsViewModel({required AnalyticsService analyticsService})
    : _analyticsService = analyticsService {
    loadAllData();
    _startPeriodicRefresh();
  }

  // --- State Variables ---
  DashboardStats? _stats;
  bool _isLoading = true;
  int _totalOrders = 0;

  List<QueueLengthDataPoint> _queueLengthData = [];
  List<TableOccupancyDataPoint> _tableOccupancyData = [];
  List<OrderValueDataPoint> _orderValueData = [];
  List<OrderSummary> _ordersLineData = [];
  List<OrderSummary> _orderSummary = [];

  // --- Timeframes (Moved from View to VM) ---
  TimeFrameOption _queueLengthTimeframe = TimeFrameOption.today;

  TimeFrameOption get queueLengthTimeframe => _queueLengthTimeframe;

  set queueLengthTimeframe(TimeFrameOption newTimeFrame) {
    _queueLengthTimeframe = newTimeFrame;
    notifyListeners();
  }

  TimeFrameOption _tableOccupancyTimeframe = TimeFrameOption.thisWeek;
  TimeFrameOption get tableOccupancyTimeframe => _tableOccupancyTimeframe;

  set tableOccupancyTimeframe(TimeFrameOption newTimeFrame) {
    _tableOccupancyTimeframe = newTimeFrame;
    notifyListeners();
  }

  TimeFrameOption _orderValueTimeframe = TimeFrameOption.thisWeek;
  TimeFrameOption get orderValueTimeframe => _orderValueTimeframe;

  set orderValueTimeframe(TimeFrameOption newTimeFrame) {
    _orderValueTimeframe = newTimeFrame;
    notifyListeners();
  }

  TimeFrameOption _ordersTimeframe = TimeFrameOption.today;
  TimeFrameOption get ordersTimeframe => _ordersTimeframe;

  set ordersTimeframe(TimeFrameOption newTimeFrame) {
    _ordersTimeframe = newTimeFrame;
    notifyListeners();
  }

  TimeFrameOption _orderSummaryTimeframe = TimeFrameOption.today;
  TimeFrameOption get orderSummaryTimeframe => _orderSummaryTimeframe;

  set orderSummaryTimeframe(TimeFrameOption newTimeFrame) {
    _orderSummaryTimeframe = newTimeFrame;
    notifyListeners();
  }

  // --- Getters ---
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  int get totalOrders => _totalOrders;
  List<QueueLengthDataPoint> get queueLengthData => _queueLengthData;
  List<TableOccupancyDataPoint> get tableOccupancyData => _tableOccupancyData;
  List<OrderValueDataPoint> get orderValueData => _orderValueData;
  List<OrderSummary> get ordersLineData => _ordersLineData;
  List<OrderSummary> get orderSummary => _orderSummary;

  // --- Logic ---

  Future<List<QueueLengthDataPoint>> loadQueueLength({
    bool notifyListener = true,
    required TimeFrameOption timeFrame,
  }) async {
    if (notifyListener) {
      notifyListeners();
    }
    return [];
  }

  Future<List<TableOccupancyDataPoint>> loadTableOccupancy({
    bool notifyListener = true,
    required TimeFrameOption timeFrame,
  }) async {
    if (notifyListener) {
      notifyListeners();
    }
    return [];
  }

  Future<List<OrderValueDataPoint>> loadAverageOrderValue({
    bool notifyListener = true,
    required TimeFrameOption timeFrame,
  }) async {
    if (notifyListener) {
      notifyListeners();
    }
    return [];
  }

  Future<List<OrderSummary>> loadOrderSummary({
    bool notifyListener = true,
    required TimeFrameOption timeFrame,
  }) async {
    if (notifyListener) {
      notifyListeners();
    }
    return [];
  }

  Future<void> loadAllData({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final results = [
        await _analyticsService.dashboardStats,
        _analyticsService.todayTotalOrders,
        await loadQueueLength(timeFrame: queueLengthTimeframe),
        await loadTableOccupancy(timeFrame: tableOccupancyTimeframe),
        await loadAverageOrderValue(timeFrame: orderValueTimeframe),
        await loadOrderSummary(timeFrame: ordersTimeframe),
        await loadOrderSummary(timeFrame: orderSummaryTimeframe),
      ];

      _stats = results[0] as DashboardStats;
      _totalOrders = results[1] as int;
      _queueLengthData = results[2] as List<QueueLengthDataPoint>;
      _tableOccupancyData = results[3] as List<TableOccupancyDataPoint>;
      _orderValueData = results[4] as List<OrderValueDataPoint>;
      _ordersLineData = results[5] as List<OrderSummary>;
      _orderSummary = results[6] as List<OrderSummary>;
    } catch (e) {
      debugPrint("Analytics Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadAllData(showLoading: false); // Refresh silently in background
    });
  }

  List<TimeFrameOption> get timeframeOptions => [
    TimeFrameOption.today,
    TimeFrameOption.thisWeek,
    TimeFrameOption.thisMonth,
    TimeFrameOption.thisYear,
  ];

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
