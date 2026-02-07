import 'history.dart';
import 'queue_entry.dart';

enum UserType { normal, store }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final List<History> histories;
  final QueueEntry? currentQueue;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.currentQueue,
    required this.id,
    required this.histories,
  });
}
