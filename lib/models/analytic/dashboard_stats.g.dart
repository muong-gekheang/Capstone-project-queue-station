// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      queueEntries: (json['queueEntries'] as num).toInt(),
      peopleWaiting: (json['peopleWaiting'] as num).toInt(),
      activeTables: (json['activeTables'] as num).toInt(),
      averageWaitTimeMinutes: (json['averageWaitTimeMinutes'] as num).toInt(),
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      averageQueueLength: (json['averageQueueLength'] as num?)?.toDouble() ?? 0,
      tableOccupancy: (json['tableOccupancy'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'queueEntries': instance.queueEntries,
      'peopleWaiting': instance.peopleWaiting,
      'activeTables': instance.activeTables,
      'averageWaitTimeMinutes': instance.averageWaitTimeMinutes,
      'totalOrders': instance.totalOrders,
      'averageQueueLength': instance.averageQueueLength,
      'tableOccupancy': instance.tableOccupancy,
    };
