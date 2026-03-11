// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueLengthDataPoint _$QueueLengthDataPointFromJson(
  Map<String, dynamic> json,
) => QueueLengthDataPoint(
  time: DateTime.parse(json['time'] as String),
  queueLength: (json['queueLength'] as num).toInt(),
);

Map<String, dynamic> _$QueueLengthDataPointToJson(
  QueueLengthDataPoint instance,
) => <String, dynamic>{
  'time': instance.time.toIso8601String(),
  'queueLength': instance.queueLength,
};

TableOccupancyDataPoint _$TableOccupancyDataPointFromJson(
  Map<String, dynamic> json,
) => TableOccupancyDataPoint(
  day: json['day'] as String,
  occupancyPercentage: (json['occupancyPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$TableOccupancyDataPointToJson(
  TableOccupancyDataPoint instance,
) => <String, dynamic>{
  'day': instance.day,
  'occupancyPercentage': instance.occupancyPercentage,
};

OrderValueDataPoint _$OrderValueDataPointFromJson(Map<String, dynamic> json) =>
    OrderValueDataPoint(
      day: json['day'] as String,
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderValueDataPointToJson(
  OrderValueDataPoint instance,
) => <String, dynamic>{
  'day': instance.day,
  'averageOrderValue': instance.averageOrderValue,
};

OrdersDataPoint _$OrdersDataPointFromJson(Map<String, dynamic> json) =>
    OrdersDataPoint(
      time: DateTime.parse(json['time'] as String),
      orderCount: (json['orderCount'] as num).toInt(),
    );

Map<String, dynamic> _$OrdersDataPointToJson(OrdersDataPoint instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'orderCount': instance.orderCount,
    };
