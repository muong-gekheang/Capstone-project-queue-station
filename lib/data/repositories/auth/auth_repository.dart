import 'package:firebase_auth/firebase_auth.dart';
import 'package:queue_station_app/models/user/customer.dart';

abstract class AuthRepository {
  Future<User?> register(Customer customer, String password);
  Future<User?> login(String email, String password);
  Future<void> signOut();
  Future<void> changeEmail(String newEmail, String password);
  Future<void> sendResetLink(String email);
  Future<void> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  );
}
