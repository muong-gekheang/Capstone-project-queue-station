import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;

  Restaurant? _currentRestaurant;
  bool _isLoading = true;
  Duration _avgWaitTime = Duration.zero;
  int _activeTable = 0;

  DashboardViewModel({required RestaurantService restaurantService})
    : _restaurantService = restaurantService {
    _subscribeToRestaurant();
    init();
  }

  void _subscribeToRestaurant() {
    _restaurantService.streamRestaurant.listen(
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

  void init() async {
    _avgWaitTime = await _restaurantService.avgWaitingTime;
    int result = 0;
    for (var table in await _restaurantService.tables) {
      if (table.queueEntryIds.isNotEmpty) {
        result++;
      }
    }
    _activeTable = result;
  }

  bool get isLoading => _isLoading;

  int get queueEntries => _currentRestaurant?.currentInQueue.length ?? 0;

  int get peopleWaiting {
    int result = 0;
    for (QueueEntry queueEntry in _currentRestaurant?.currentInQueue ?? []) {
      result += queueEntry.partySize;
    }
    return result;
  }

  int get activeTable => _activeTable;

  Duration get avgWaitTime => _avgWaitTime;
}
