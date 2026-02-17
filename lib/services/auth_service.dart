import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    User newUser = email.isEmpty ? mockUsers[0] : mockUsers[1];

    return newUser;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }
}
