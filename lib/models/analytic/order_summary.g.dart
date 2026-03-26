// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) => OrderSummary(
  time: DateTime.parse(json['time'] as String),
  tableNumber: json['tableNumber'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$OrderSummaryToJson(OrderSummary instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'tableNumber': instance.tableNumber,
      'amount': instance.amount,
    };
