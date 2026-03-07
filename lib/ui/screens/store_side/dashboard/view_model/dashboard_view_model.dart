import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/restaurant_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  StreamSubscription<Restaurant?>? _restaurantSubscription;
  Restaurant? _currentRestaurant;
  bool _isLoading = false;

  DashboardViewModel({required RestaurantService restaurantService})
    : _restaurantService = restaurantService {
    _subscribeToRestaurant();
  }

  void _subscribeToRestaurant() {
    _restaurantSubscription = _restaurantService.streamRestaurant.listen(
      (restaurant) {
        _currentRestaurant = restaurant;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    super.dispose();
  }

  int get queueEntries => _currentRestaurant?.currentInQueue.length ?? 0;

  int get peopleWaiting {
    int result = 0;
    for (QueueEntry queueEntry in _currentRestaurant?.currentInQueue ?? []) {
      result += queueEntry.partySize;
    }
    return result;
  }

  int get activeTable {
    int result = 0;
    for (String tableId in _currentRestaurant?.tableIds ?? []) {
      if (table.customers.isNotEmpty) {
        result++;
      }
    }
    return result;
  }

  Duration get avgWaitTime => _restaurant.averageWaitingTime;
}
