import 'package:flutter/material.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/restaurant_service.dart';
import 'package:queue_station_app/services/user_provider.dart';

class DashboardViewModel extends ChangeNotifier {
  final UserProvider _userProvider;
  final RestaurantService _restaurantService;
  late Restaurant _restaurant;

  DashboardViewModel({
    required UserProvider userProvider,
    required RestaurantService restaurantService,
  }) : _userProvider = userProvider,
       _restaurantService = restaurantService {
    init();
  }

  void init() {
    _restaurant = _restaurantService.restaurant;
  }

  int get queueEntries => _restaurant.currentInQueue.length;

  int get peopleWaiting {
    int result = 0;
    for (QueueEntry queueEntry in _restaurant.currentInQueue) {
      result += queueEntry.partySize;
    }
    return result;
  }

  int get activeTable {
    int result = 0;
    for (QueueTable table in _restaurant.tables) {
      if (table.customers.isNotEmpty) {
        result++;
      }
    }
    return result;
  }

  Duration get avgWaitTime => _restaurant.averageWaitingTime;
}
