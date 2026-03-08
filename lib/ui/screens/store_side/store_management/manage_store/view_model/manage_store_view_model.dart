import 'package:flutter/material.dart';

class ManageStoreViewModel extends ChangeNotifier {
  bool _isStoreOpen = true;
  bool get isStoreOpen => _isStoreOpen;

  void updateStoreStatus(bool isOpen) {
    _isStoreOpen = isOpen;
  }
}
