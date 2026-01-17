class QueueLengthDataPoint {
  final DateTime time;
  final int queueLength;

  QueueLengthDataPoint({
    required this.time,
    required this.queueLength,
  });
}

class TableOccupancyDataPoint {
  final String day;
  final double occupancyPercentage;

  TableOccupancyDataPoint({
    required this.day,
    required this.occupancyPercentage,
  });
}

class OrderValueDataPoint {
  final String day;
  final double averageOrderValue;

  OrderValueDataPoint({
    required this.day,
    required this.averageOrderValue,
  });
}

class OrdersDataPoint {
  final DateTime time;
  final int orderCount;

  OrdersDataPoint({
    required this.time,
    required this.orderCount,
  });
}
