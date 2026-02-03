import 'package:queue_station_app/model/user.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isEmpty
        ? User(
            name: "Monica",
            email: "monica@gmail.com",
            phone: "0987654321",
            userType: UserType.normal,
          )
        : User(
            name: "Monica",
            email: "monica@gmail.com",
            phone: "0987654321",
            userType: UserType.store,
          );
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }
}
