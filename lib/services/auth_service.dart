import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';

class AuthService {
  // TODO: Implement the login (rn just this for easier development)
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    User newUser = email.isEmpty ? mockUsers[0] : mockUsers[1];
    return newUser;
  }

  Future<bool> register({
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    mockUsers.add(
      Customer(
        name: username,
        email: email,
        phone: phoneNumber,
        id: uuid.v4(),
        histories: [],
      ),
    );
    return true;
  }
}
