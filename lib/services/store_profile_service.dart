
import 'dart:io';

import 'package:flutter/foundation.dart';

class StoreProfileService extends ChangeNotifier {
  static final StoreProfileService _instance = StoreProfileService._internal();
  factory StoreProfileService() => _instance;
  StoreProfileService._internal();

  File? _storeProfileImage;
  String _storeName = 'Kungfu Kitchen';

  File? get storeProfileImage => _storeProfileImage;
  String get storeName => _storeName;

  void setStoreProfileImage(File? image) {
    _storeProfileImage = image;
    notifyListeners();
  }

  void setStoreName(String name) {
    _storeName = name;
    notifyListeners();
  }

  void addListener(void Function() onProfileChanged) {
    super.addListener(onProfileChanged);
  }

  void removeListener(void Function() onProfileChanged) {
    super.removeListener(onProfileChanged);
  }
}
