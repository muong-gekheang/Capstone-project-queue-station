import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/navigation/store_side_bottom_nav.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/navigation/store_side_nav_router.dart';
import '../../../../core/models/dashboard_stats.dart';
import '../../../../core/models/analytics_data.dart';
import '../../../../core/repositories/queue_repository.dart';
import '../../../../services/queue_service.dart';
import '../../../../services/store_profile_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final QueueService _queueService = QueueService(QueueRepository());
  final QueueRepository _repository = QueueRepository();
  
  DashboardStats? _stats;
  bool _isLoading = true;
  
  String _queueLengthTimeframe = 'Today';
  String _tableOccupancyTimeframe = 'This Week';
  String _orderValueTimeframe = 'This Week';
  String _ordersTimeframe = 'Today';

  List<QueueLengthDataPoint> _queueLengthData = [];
  List<TableOccupancyDataPoint> _tableOccupancyData = [];
  List<OrderValueDataPoint> _orderValueData = [];
  List<OrdersDataPoint> _ordersData = [];
  int _totalOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
    _startPeriodicRefresh();
  }

  void _loadAnalyticsData() async {
    try {
      final stats = await _queueService.getDashboardStats();
      final totalOrders = await _repository.getTotalOrdersCount();
      final queueLengthData = await _repository.getQueueLengthData(_queueLengthTimeframe);
      final tableOccupancyData = await _repository.getTableOccupancyData(_tableOccupancyTimeframe);
      final orderValueData = await _repository.getAverageOrderValueData(_orderValueTimeframe);
      final ordersData = await _repository.getOrdersData(_ordersTimeframe);

      if (mounted) {
        setState(() {
          _stats = stats;
          _totalOrders = totalOrders;
          _queueLengthData = queueLengthData;
          _tableOccupancyData = tableOccupancyData;
          _orderValueData = orderValueData;
          _ordersData = ordersData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startPeriodicRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadAnalyticsData();
        _startPeriodicRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.bar_chart, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text(
              'Analytic',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Store Profile Image
          _buildStoreProfileImage(),
          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat Cards
                  _buildStatCard(
                    'People Waiting',
                    '${_stats?.peopleWaiting ?? 0}',
                    '',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Average Wait Time',
                    '${_stats?.averageWaitTimeMinutes ?? 0}',
                    'min',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Active Tables',
                    '${_stats?.activeTables ?? 0}',
                    '',
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Orders',
                    '$_totalOrders',
                    'orders',
                  ),
                  const SizedBox(height: 24),
                  // Queue Length Chart
                  _buildQueueLengthChart(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        selectedTab: NavTab.analytics,
        onTabSelected: (tab) {
          if (tab == NavTab.analytics) return;
          NavRouter.handleTabSelection(context, tab);
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueueLengthChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUEUE LENGTH',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Show timeframe selector
                },
                child: Row(
                  children: [
                    Text(
                      _queueLengthTimeframe,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (_queueLengthData.isEmpty) return const Text('');
                        final index = value.toInt();
                        if (index >= 0 && index < _queueLengthData.length) {
                          final hour = _queueLengthData[index].time.hour;
                          if (hour == 8 || hour == 10 || hour == 13 || hour == 15 || hour == 17 || hour == 19) {
                            return Text(
                              '${hour}:00',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _queueLengthData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.queueLength.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF2563EB),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                    ),
                  ),
                ],
                minY: 0,
                maxY: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreProfileImage() {
    final storeService = StoreProfileService();
    final profileImage = storeService.storeProfileImage;
    final storeName = storeService.storeName;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: profileImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                profileImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6835).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    color: Color(0xFFFF6835),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }
}
