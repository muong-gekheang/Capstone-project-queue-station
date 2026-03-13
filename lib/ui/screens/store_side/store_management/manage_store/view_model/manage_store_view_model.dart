import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';

class ManageStoreViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  StreamSubscription<Restaurant?>? _streamSubscription;
  Restaurant? _currentRest;
  bool isLoading = true;
  bool isDisposed = false;

  ManageStoreViewModel({required RestaurantService restaurantService})
    : _restaurantService = restaurantService {
    _subscribe();
  }

  void _subscribe() {
    _streamSubscription = _restaurantService.streamRestaurant.listen(
      (restaurant) {
        print("STATUS ${restaurant?.isOpen}");

        if (isDisposed) return;
        _currentRest = restaurant;
        isLoading = false;
        notifyListeners();
      },
      onError: (err) {
        if (isDisposed) return;
        isLoading = false;
        print("ERROR: $err");
        notifyListeners();
      },
    );
  }

  bool get isStoreOpen => _currentRest?.isOpen ?? false;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    isDisposed = true;
    super.dispose();
  }

  void updateStoreStatus(bool isOpen) {
    _restaurantService.updateStoreStatus(isOpen);
    isLoading = true;
    notifyListeners();
  }
}
