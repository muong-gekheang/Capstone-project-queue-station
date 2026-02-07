import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void updateUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }
}
