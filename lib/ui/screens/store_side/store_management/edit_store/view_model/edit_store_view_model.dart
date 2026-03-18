import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';

class EditStoreViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  final StoreProfileService _storeProfileService;
  final AuthService _authService;
  final FirebaseAuth _firebaseAuth;
  bool _isDisposed = false;

  Restaurant? _currentRestaurant;
  bool _isLoading = true;

  StreamSubscription<Restaurant?>? _restaurantSubscription;

  EditStoreViewModel({
    required RestaurantService restaurantService,
    required StoreProfileService storeProfileService,
    FirebaseAuth? firebaseAuth,
    required AuthService authService,
  }) : _restaurantService = restaurantService,
       _storeProfileService = storeProfileService,
       _authService = authService,
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

  void sendVerifyEmail(String password) async {
    await AuthRepository.reauthenticate(password);
    _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> onSave({
    File? selectedImage,
    required String newStoreName,
    required String newDescription,
    required String password,
    required String userEmail,
    required String storeEmail,
  }) async {
    _storeProfileService.setStoreProfileImage(selectedImage);
    if (_currentRestaurant != null) {
      _restaurantService.updateRestaurant(
        _currentRestaurant!.copyWith(
          name: newStoreName,
          description: newDescription,
          email: storeEmail,
        ),
      );

      if (userEmail != adminEmail && userEmail != "Unknown") {
        try {
          await _authService.changeEmail(userEmail, password);
        } catch (e) {
          debugPrint("EMAIL: $e");
        }
      }
    }
  }

  bool get isLoading => _isLoading;

  String get storeName => _currentRestaurant?.name ?? "Unknown";

  String get storeEmail => _currentRestaurant?.email ?? "Unknown";

  String get storeDescription => "";

  String get adminEmail => _restaurantService.storeUser?.email ?? "Unknown";
}
