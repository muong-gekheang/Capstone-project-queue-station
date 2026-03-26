import 'package:json_annotation/json_annotation.dart';

part 'order_summary.g.dart';

@JsonSerializable()
class OrderSummary {
  final DateTime time;
  final String tableNumber;
  final double amount;

  OrderSummary({
    required this.time,
    required this.tableNumber,
    required this.amount,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryToJson(this);
}
