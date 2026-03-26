import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    return DateTime.parse(json as String); // Fallback for old ISO strings
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}
