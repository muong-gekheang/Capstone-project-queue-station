import 'history.dart';

enum UserType { normal, store }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final List<History> histories;
  final History? currentHistory;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.currentHistory,
    required this.id,
    required this.histories,
  });

  User copyWith({
    String? name,
    String? id,
    String? email,
    String? phone,
    UserType? userType,
    List<History>? histories,
    History? currentHistory,
    bool? isNoQueue,
  }) => User(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    userType: userType ?? this.userType,
    id: id ?? this.id,
    histories: histories ?? this.histories,
    currentHistory: isNoQueue != null
        ? (isNoQueue ? null : currentHistory ?? this.currentHistory)
        : currentHistory ?? this.currentHistory,
  );
}
