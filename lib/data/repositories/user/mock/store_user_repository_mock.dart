import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';

class StoreUserRepositoryMock implements UserRepository<StoreUser> {
  Map<String, StoreUser> storeUsers = {};

  StoreUserRepositoryMock() {
    for (var storeUser in mockStoreUsers) {
      storeUsers[storeUser.id] = storeUser;
    }
  }
  @override
  Future<StoreUser> create(StoreUser user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<StoreUser>> getAll({int? limit, String? search}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<StoreUser?> getByEmail(String email) {
    // TODO: implement getByEmail
    throw UnimplementedError();
  }

  @override
  Future<StoreUser?> getByPhoneNumber(String phoneNumber) {
    // TODO: implement getByPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<StoreUser?> getUserById(String id) async {
    return storeUsers[id];
  }

  @override
  Future<StoreUser> update(StoreUser user) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
