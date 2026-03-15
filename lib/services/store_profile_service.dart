import 'dart:io';
import 'package:flutter/foundation.dart';

class StoreProfileService extends ChangeNotifier {
  static final StoreProfileService _instance = StoreProfileService._internal();
  factory StoreProfileService() => _instance;
  StoreProfileService._internal();

  File? _storeProfileImage;
  Uint8List? _storeProfileImageBytes;
  String _storeName = 'Kungfu Kitchen';

  File? get storeProfileImage => _storeProfileImage;
  Uint8List? get storeProfileImageBytes => _storeProfileImageBytes;
  String get storeName => _storeName;

  void setStoreProfileImage(File? image) {
    _storeProfileImage = image;
    notifyListeners();
  }

  void setStoreProfileImageBytes(Uint8List? bytes) {
    _storeProfileImageBytes = bytes;
    notifyListeners();
  }

  void setStoreName(String name) {
    _storeName = name;
    notifyListeners();
  }
}
