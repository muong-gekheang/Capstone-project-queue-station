import 'package:flutter/material.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isRestoring = true;

  bool get isRestoring => _isRestoring;

  User? get currentUser => _currentUser;

  Customer? get asCustomer =>
      _currentUser is Customer ? _currentUser as Customer : null;

  StoreUser? get asStoreUser =>
      _currentUser is StoreUser ? _currentUser as StoreUser : null;

  void setRestored() {
    _isRestoring = false;
    notifyListeners();
  }

  void updateUser(User? newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
