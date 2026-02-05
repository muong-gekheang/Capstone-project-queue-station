import 'package:queue_station_app/model/restaurant.dart';

enum UserType { normal, store }

class User {
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  Restaurant? restaurant; // TODO: Change implementation later

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.restaurant,
  });

  bool get isJoinedQueue => restaurant != null;
}
