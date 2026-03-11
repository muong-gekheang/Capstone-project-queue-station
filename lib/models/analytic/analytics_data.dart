import 'package:json_annotation/json_annotation.dart';

part 'analytics_data.g.dart';

@JsonSerializable()
class QueueLengthDataPoint {
  final DateTime time;
  final int queueLength;

  QueueLengthDataPoint({required this.time, required this.queueLength});

  factory QueueLengthDataPoint.fromJson(Map<String, dynamic> json) =>
      _$QueueLengthDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$QueueLengthDataPointToJson(this);
}

@JsonSerializable()
class TableOccupancyDataPoint {
  final DateTime day;
  final double occupancyPercentage;

  TableOccupancyDataPoint({
    required this.day,
    required this.occupancyPercentage,
  });

  factory TableOccupancyDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TableOccupancyDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$TableOccupancyDataPointToJson(this);
}

@JsonSerializable()
class OrderValueDataPoint {
  final String day;
  final double averageOrderValue;

  OrderValueDataPoint({required this.day, required this.averageOrderValue});

  factory OrderValueDataPoint.fromJson(Map<String, dynamic> json) =>
      _$OrderValueDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$OrderValueDataPointToJson(this);
}

@JsonSerializable()
class OrdersDataPoint {
  final DateTime time;
  final int orderCount;

  OrdersDataPoint({required this.time, required this.orderCount});

  factory OrdersDataPoint.fromJson(Map<String, dynamic> json) =>
      _$OrdersDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersDataPointToJson(this);
}
