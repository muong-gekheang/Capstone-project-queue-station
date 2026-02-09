import 'package:queue_station_app/models/user/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    User newUser = email.isEmpty
        ? User(
            id: Uuid().v4(),
            histories: [],
            name: "Monica",
            email: "monica@gmail.com",
            phone: "0987654321",
            userType: UserType.normal,
          )
        : User(
            id: Uuid().v4(),
            histories: [],
            name: "Monica",
            email: "monica@gmail.com",
            phone: "0987654321",
            userType: UserType.store,
          );

    return newUser;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }
}
