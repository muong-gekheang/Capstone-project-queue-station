import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats.g.dart';

@JsonSerializable()
class DashboardStats {
  final int queueEntries;
  final int peopleWaiting;
  final int activeTables;
  final int averageWaitTimeMinutes;
  final int totalOrders;
  final double averageQueueLength;
  final double tableOccupancy;

  DashboardStats({
    required this.queueEntries,
    required this.peopleWaiting,
    required this.activeTables,
    required this.averageWaitTimeMinutes,
    this.totalOrders = 0,
    this.averageQueueLength = 0,
    this.tableOccupancy = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}
