import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';

class EditStoreViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  final StoreProfileService _storeProfileService;
  final FirebaseAuth _firebaseAuth;
  bool _isDisposed = false;

  Restaurant? _currentRestaurant;
  bool _isLoading = true;

  StreamSubscription<Restaurant?>? _restaurantSubscription;

  EditStoreViewModel({
    required RestaurantService restaurantService,
    required StoreProfileService storeProfileService,
    FirebaseAuth? firebaseAuth,
  }) : _restaurantService = restaurantService,
       _storeProfileService = storeProfileService,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _subscribeToRestaurant();
  }

  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  void _subscribeToRestaurant() {
    _restaurantSubscription = _restaurantService.streamRestaurant.listen(
      (restaurant) {
        if (_isDisposed) return;
        debugPrint("Rest: ${restaurant?.name}");
        _currentRestaurant = restaurant;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        if (_isDisposed) return;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  void sendVerifyEmail() {
    _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> onSave(
    File? selectedImage,
    String newStoreName,
    String newDescription,
  ) async {
    _storeProfileService.setStoreProfileImage(selectedImage);
    if (_currentRestaurant != null) {
      _restaurantService.updateRestaurant(
        _currentRestaurant!.copyWith(
          name: newStoreName,
          description: newDescription,
        ),
      );
    }
  }

  bool get isLoading => _isLoading;

  String get storeName => _currentRestaurant?.name ?? "Unknown";

  String get storeDescription => "";

  String get adminEmail => _restaurantService.storeUser?.email ?? "Unknown";
}
