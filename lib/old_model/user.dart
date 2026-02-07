import 'package:queue_station_app/old_model/restaurant.dart';

enum UserType { normal, store }

class User {
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final Restaurant? restaurant; // TODO: Change implementation later

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.restaurant,
  });

  bool get isJoinedQueue => restaurant != null;

  User copyWith({
    String? name,
    String? email,
    String? phone,
    UserType? userType,
    Restaurant? restaurant,
    bool noRestaurant = false,
  }) => User(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    userType: userType ?? this.userType,
    restaurant: restaurant ?? (noRestaurant ? null : this.restaurant),
  );
}
