import 'package:queue_station_app/models/user/abstracts/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);
  Future<User?> getByEmail(String email);
  Future<List<User>> getAll({int? limit, String? search});
  Future<User> create(User user);
  Future<User> update(User user);
  Future<void> delete(String id);
  Future<User?> getCurrentUser();
  Stream<User?> watchCurrentUser();
}
