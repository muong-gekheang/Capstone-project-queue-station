import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserProvider _userProvider;

  bool _isLoading = false;
  String? _error;

  SettingsViewModel({
    required AuthRepository authRepository,
    required UserProvider userProvider,
  }) : _authRepository = authRepository,
       _userProvider = userProvider;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Logout the current user
  Future<bool> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Sign out from Firebase Auth
      await _authRepository.signOut();

      // Clear user from provider
      _userProvider.clearUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // /// Delete user account (requires password verification)
  // Future<bool> deleteAccount(String password) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final user = _authRepository.getCurrentUser();
  //     if (user == null) {
  //       throw Exception('No authenticated user found');
  //     }

  //     final email = user.email;
  //     if (email == null) {
  //       throw Exception('User email not found');
  //     }

  //     // Re-authenticate before deletion
  //     final credential = EmailAuthProvider.credential(
  //       email: email,
  //       password: password,
  //     );

  //     await user.reauthenticateWithCredential(credential);

  //     // Delete user account
  //     await user.delete();

  //     // Clear user from provider
  //     _userProvider.clearUser();

  //     _isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'wrong-password':
  //         _error = 'Incorrect password';
  //         break;
  //       case 'requires-recent-login':
  //         _error = 'Please log in again before deleting your account';
  //         break;
  //       default:
  //         _error = e.message ?? 'Failed to delete account';
  //     }
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }
}
