import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
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

  static Future<void> reauthenticate(String password) async {
    final user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!, // The current (potentially fake) email
      password: password,
    );
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      debugPrint("REAUTH: $e");
    }
  }
}
