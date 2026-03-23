import 'package:flutter/material.dart';
import 'package:queue_station_app/services/store/auth_service.dart';

class StoreSettingsViewModel extends ChangeNotifier {
  final AuthService _authService;
  StoreSettingsViewModel({required AuthService authService})
    : _authService = authService;

  void signOut() {
    _authService.signOut();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authService.changePassword(oldPassword, newPassword);
  }

  Future<void> sendResetPasswordLink(String email) async {
    await _authService.sendResetPasswordLink(email);
  }
}
