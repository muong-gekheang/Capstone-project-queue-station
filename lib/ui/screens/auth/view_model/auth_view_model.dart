import 'package:flutter/foundation.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/store/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel({required AuthService authService})
    : _authService = authService;

  bool _isLoading = false;
  bool _isSubscriptionExpired = false;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isSubscriptionExpired => _isSubscriptionExpired;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _isSubscriptionExpired = false;
    notifyListeners();
    var user = await _authService.login(email, password);
    if (_disposed) return false;
    if (user != null) {
      final isActive = await _authService.checkSubscriptionStatus(user);
      if (_disposed) return false;
      if (!isActive) {
        _isLoading = false;
        _isSubscriptionExpired = true;
        notifyListeners();
        return false;
      }
    }
    _isLoading = false;
    notifyListeners();
    return user != null;
  }

  Future<bool> register({
    required Customer customer,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    var user = await _authService.register(customer, password);
    if (_disposed) return false;
    _isLoading = false;
    notifyListeners();
    return user != null;
  }
}
