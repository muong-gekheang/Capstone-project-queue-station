import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/queue_repository.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
import 'package:queue_station_app/services/store_profile_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';

class AnalyticsContent extends StatefulWidget {
  const AnalyticsContent({super.key});

  @override
  State<AnalyticsContent> createState() => _AnalyticsContentState();
}

class _AnalyticsContentState extends State<AnalyticsContent> {
  void _showTimeframeSelector(
    String chartType,
    String currentTimeframe,
    Function(String) onSelected,
  ) {
    AnalyticsViewModel analyticsViewModel = context.read<AnalyticsViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: analyticsViewModel.timeframeOptions.map((timeframe) {
            return ListTile(
              title: Text(timeframe),
              trailing: currentTimeframe == timeframe
                  ? const Icon(Icons.check, color: Color(0xFFFF6835))
                  : null,
              onTap: () {
                onSelected(timeframe);
                Navigator.pop(context);
                analyticsViewModel.loadAllData();
              },
            );
          }).toList(),
        ),
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
                color: const Color(0xFFFF6835).withAlpha((255 * 0.1).toInt()),
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

  @override
  Widget build(BuildContext context) {
    AnalyticsViewModel analyticsViewModel = context.watch<AnalyticsViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.bar_chart, color: Color(0xFF0D47A1)),
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
          _buildStoreProfileImage(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: analyticsViewModel.isLoading
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
                  _buildStatCard('Orders', '$_totalOrders', 'orders'),
                  const SizedBox(height: 24),

                  // Queue Length Chart
                  _buildQueueLengthChart(),
                  const SizedBox(height: 24),

                  // Table Occupancy Chart
                  _buildTableOccupancyChart(),
                  const SizedBox(height: 24),

                  // Average Order Value Chart
                  _buildAverageOrderValueChart(),
                  const SizedBox(height: 24),

                  // Orders Line Chart
                  _buildOrdersLineChart(),
                  const SizedBox(height: 24),

                  // Order Summary Table
                  _buildOrderSummaryTable(),
                  const SizedBox(height: 24),
                ],
              ),
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
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                  color: Color(0xFF0D47A1),
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
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                onTap: () => _showTimeframeSelector(
                  'queueLength',
                  _queueLengthTimeframe,
                  (value) => setState(() => _queueLengthTimeframe = value),
                ),
                child: Row(
                  children: [
                    Text(
                      _queueLengthTimeframe,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
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
                          final time = _queueLengthData[index].time;
                          if (_queueLengthTimeframe == 'Today') {
                            final hour = time.hour;
                            if (hour == 8 ||
                                hour == 10 ||
                                hour == 13 ||
                                hour == 15 ||
                                hour == 17 ||
                                hour == 19) {
                              return Text(
                                '$hour:00',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          } else {
                            return Text(
                              '${time.day}/${time.month}',
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
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.queueLength.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF7987FF),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(
                        0xFF7987FF,
                      ).withAlpha((255 * 0.1).toInt()),
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

  Widget _buildTableOccupancyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                'TABLE OCCUPANCY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => _showTimeframeSelector(
                  'tableOccupancy',
                  _tableOccupancyTimeframe,
                  (value) => setState(() => _tableOccupancyTimeframe = value),
                ),
                child: Row(
                  children: [
                    Text(
                      _tableOccupancyTimeframe,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (_tableOccupancyData.isEmpty) return const Text('');
                        final index = value.toInt();
                        if (index >= 0 && index < _tableOccupancyData.length) {
                          return Text(
                            _tableOccupancyData[index].day,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
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
                barGroups: _tableOccupancyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.occupancyPercentage,
                        color: const Color(0xFF7987FF),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageOrderValueChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                'AVERAGE ORDER VALUE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => _showTimeframeSelector(
                  'orderValue',
                  _orderValueTimeframe,
                  (value) => setState(() => _orderValueTimeframe = value),
                ),
                child: Row(
                  children: [
                    Text(
                      _orderValueTimeframe,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => Text(
                        '\$${value.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (_orderValueData.isEmpty) return const Text('');
                        final index = value.toInt();
                        if (index >= 0 && index < _orderValueData.length) {
                          return Text(
                            _orderValueData[index].day,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
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
                barGroups: _orderValueData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.averageOrderValue,
                        color: const Color(0xFF7987FF),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                maxY: 600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersLineChart() {
    if (_ordersLineData.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                'ORDERS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _showTimeframeSelector(
                  'orders',
                  _ordersTimeframe,
                  (v) => setState(() => _ordersTimeframe = v),
                ),
                child: Row(
                  children: [
                    Text(
                      _ordersTimeframe,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 3,
                    color: const Color(0xFF7987FF),
                    spots: _ordersLineData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.amount))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
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
                'ORDER SUMMARY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => _showTimeframeSelector(
                  'orderSummary',
                  _orderSummaryTimeframe,
                  (value) {
                    setState(() {
                      _orderSummaryTimeframe = value;
                      _isLoading = true;
                    });
                    _loadAnalyticsData();
                  },
                ),
                child: Row(
                  children: [
                    Text(
                      _orderSummaryTimeframe,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _orderSummary.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No order summary data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : DataTable(
                  columns: const [
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Table')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: _orderSummary.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Text(order.time)),
                        DataCell(Text(order.tableNumber)),
                        DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
                      ],
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
