import 'package:queue_station_app/models/user/abstracts/user.dart';

abstract class UserRepository<T extends User> {
  Future<T?> getUserById(String id);
  Future<T?> getByEmail(String email);
  Future<T?> getByPhoneNumber(String phoneNumber);
  Future<List<T>> getAll({int? limit, String? search});
  Future<T> create(T user);
  Future<T> update(T user);
  Future<void> delete(String id);
}
