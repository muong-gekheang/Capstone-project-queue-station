import 'package:queue_station_app/models/user/abstracts/user.dart';

// abstract class UserRepository {
//   Future<User?> getUserById(String id);
//   Future<User?> getByEmail(String email);
//   Future<User?> getByPhoneNumber(String phoneNumber);
//   Future<List<User>> getAll({int? limit, String? search});
//   Future<User> create(User user);
//   Future<User> update(User user);
//   Future<void> delete(String id);
//   Future<User?> getCurrentUser();
//   Stream<User?> watchCurrentUser();
// }

abstract class UserRepository<T extends User> {
  Future<T?> getUserById(String id);
  Future<T?> getByEmail(String email);
  Future<T?> getByPhoneNumber(String phoneNumber);
  Future<List<T>> getAll({int? limit, String? search});
  Future<T> create(T user);
  Future<T> update(T user);
  Future<void> delete(String id);
}
