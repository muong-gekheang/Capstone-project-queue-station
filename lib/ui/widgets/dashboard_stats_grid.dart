import 'package:flutter/material.dart';
import 'package:queue_station_app/models/analytic/dashboard_stats.dart';
import 'dashboard_stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardStats? stats;
  final bool isLoading;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const DashboardStatsGrid({
    super.key,
    required this.stats,
    this.isLoading = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        DashboardStatCard(
          label: 'Queue Status',
          value: '${stats?.queueEntries ?? 0}',
          unit: 'entries',
        ),
        const SizedBox(height: 12),
        DashboardStatCard(
          label: 'People Waiting',
          value: '${stats?.peopleWaiting ?? 0}',
          unit: '',
        ),
        const SizedBox(height: 12),
        DashboardStatCard(
          label: 'Active Tables',
          value: '${stats?.activeTables ?? 0}',
          unit: '',
        ),
        const SizedBox(height: 12),
        DashboardStatCard(
          label: 'Average Wait Time',
          value: '${stats?.averageWaitTimeMinutes ?? 0}',
          unit: 'min',
        ),
      ],
    );
  }
}
