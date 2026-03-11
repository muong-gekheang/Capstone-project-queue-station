import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';

class CustomerRepositoryMock implements UserRepository<Customer> {
  Map<String, Customer> customers = {};

  CustomerRepositoryMock() {
    for (var customer in mockCustomers) {
      customers[customer.id] = customer;
    }
  }
  @override
  Future<Customer> create(Customer user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> getAll({int? limit, String? search}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getByEmail(String email) {
    // TODO: implement getByEmail
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getByPhoneNumber(String phoneNumber) {
    // TODO: implement getByPhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getUserById(String id) async {
    return customers[id];
  }

  @override
  Future<Customer> update(Customer user) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
