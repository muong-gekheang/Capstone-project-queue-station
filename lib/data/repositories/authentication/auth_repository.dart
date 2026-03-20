import 'package:firebase_auth/firebase_auth.dart';
import 'package:queue_station_app/models/user/customer.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(Customer customer, String password);
  Future<void> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  );
  Future<void> signOut();
  User? getCurrentUser();
}
