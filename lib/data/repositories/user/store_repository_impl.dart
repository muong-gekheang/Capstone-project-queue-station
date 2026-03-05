import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

class StoreRepositoryImpl implements UserRepository{
  @override
  Future<User> create(User user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAll({int? limit, String? search}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<User?> getByEmail(String email) {
    // TODO: implement getByEmail
    throw UnimplementedError();
  }

  @override
  Future<User?> getByPhoneNumber(String phoneNumber) {
    // TODO: implement getByPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<User> update(User user) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<User?> watchCurrentUser() {
    // TODO: implement watchCurrentUser
    throw UnimplementedError();
  }
}