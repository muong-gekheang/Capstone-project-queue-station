import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    User newUser = email.isEmpty ? mockUsers[0] : mockUsers[5];
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
        historyIds: [],
      ),
    );
    return true;
  }
}
