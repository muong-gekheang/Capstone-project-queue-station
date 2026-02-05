enum UserType { normal, store }

class User {
  final String name;
  final String email;
  final String phone;
  final UserType userType;

  const User({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });
}
