class Order {
  final String id;
  final String tableNumber;
  final double totalAmount;
  final DateTime orderTime;
  final String status; // 'pending', 'completed', 'cancelled'

  Order({
    required this.id,
    required this.tableNumber,
    required this.totalAmount,
    required this.orderTime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'totalAmount': totalAmount,
      'orderTime': orderTime.toIso8601String(),
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      tableNumber: json['tableNumber'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderTime: DateTime.parse(json['orderTime'] as String),
      status: json['status'] as String,
    );
  }
}
