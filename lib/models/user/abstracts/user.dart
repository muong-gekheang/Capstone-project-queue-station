abstract class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.id,
    DateTime? createdAt
  }): createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson();
}
