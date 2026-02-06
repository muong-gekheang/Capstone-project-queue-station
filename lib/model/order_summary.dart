class OrderSummary {
  final String time;
  final String tableNumber;
  final double amount;

  OrderSummary(String s, int i, {
    required this.time,
    required this.tableNumber,
    required this.amount, required String id,
  });
}
