import 'package:queue_station_app/model/entities/restaurant.dart';

enum StatusType { Completed, Pending }

class History {
  final Restaurant rest;
  final int guests;
  final String queueId;
  final DateTime queueDate; // TODO: Review? Is it the joined Date?
  final StatusType status;

  const History({
    required this.rest,
    required this.guests,
    required this.queueId,
    required this.queueDate,
    required this.status,
  });
}
