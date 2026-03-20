import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/authentication/auth_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final UserProvider userProvider;

  ChangePasswordViewModel({
    required this.authRepository,
    required this.userProvider,
  });

  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? get email => userProvider.currentUser?.email;

  Future<String?> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return null;
    }

    final email = this.email;
    if (email == null) {
      return "User not authenticated";
    }

    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.changePassword(
        email,
        oldPasswordController.text.trim(),
        newPasswordController.text.trim(),
      );

      return "Password updated successfully";
    } catch (e) {
      return e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
