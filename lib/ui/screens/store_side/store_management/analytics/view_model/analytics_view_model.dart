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
  String queueLengthTimeframe = 'Today';
  String tableOccupancyTimeframe = 'This Week';
  String orderValueTimeframe = 'This Week';
  String ordersTimeframe = 'Today';
  String orderSummaryTimeframe = 'Today';

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

  Future<void> loadAllData({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final results = await Future.wait([
        _analyticsService.dashboardStats,
        _analyticsService.totalOrders,
        _analyticsService.getQueueLengthData(queueLengthTimeframe),
        _analyticsService.getTableOccupancyData(tableOccupancyTimeframe),
        _analyticsService.getAverageOrderValueData(orderValueTimeframe),
        _analyticsService.getOrderSummary(ordersTimeframe),
        _analyticsService.getOrderSummary(orderSummaryTimeframe),
      ]);

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

  // Handle timeframe changes
  void updateTimeframe(String type, String value) {
    switch (type) {
      case 'queueLength':
        queueLengthTimeframe = value;
        break;
      case 'tableOccupancy':
        tableOccupancyTimeframe = value;
        break;
      case 'orderValue':
        orderValueTimeframe = value;
        break;
      case 'orders':
        ordersTimeframe = value;
        break;
      case 'orderSummary':
        orderSummaryTimeframe = value;
        break;
    }
    loadAllData(); // Refresh specific data
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadAllData(showLoading: false); // Refresh silently in background
    });
  }

  List<String> get timeframeOptions => [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
