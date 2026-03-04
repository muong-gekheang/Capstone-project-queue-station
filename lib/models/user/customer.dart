import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class Customer extends User {
  final List<QueueEntry> histories;
  final QueueEntry? currentHistory;

  Customer({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    required this.histories,
    this.currentHistory,
  });

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? id,
    List<QueueEntry>? histories,
    QueueEntry? currentHistory,
    bool? noQueue,
  }) {
    return Customer(
      name: name ?? super.name,
      email: email ?? super.email,
      phone: phone ?? super.phone,
      id: id ?? super.id,
      histories: histories ?? this.histories,
      currentHistory: (noQueue ?? false)
          ? null
          : currentHistory ?? this.currentHistory,
    );
  }
}
