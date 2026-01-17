import 'dart:io';

class StoreProfileService {
  static final StoreProfileService _instance = StoreProfileService._internal();
  factory StoreProfileService() => _instance;
  StoreProfileService._internal();

  File? _storeProfileImage;
  String _storeName = 'Kungfu Kitchen';

  File? get storeProfileImage => _storeProfileImage;
  String get storeName => _storeName;

  void setStoreProfileImage(File? image) {
    _storeProfileImage = image;
  }

  void setStoreName(String name) {
    _storeName = name;
  }
}
