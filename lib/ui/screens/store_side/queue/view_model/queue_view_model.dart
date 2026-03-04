import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/history.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/restaurant_service.dart';

class QueueViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  late Restaurant _restaurant;

  QueueViewModel({required RestaurantService restaurantService})
    : _restaurantService = restaurantService {
    init();
  }

  void init() {
    _restaurant = _restaurantService.restaurant;
  }

  // List<History> get currentQueue => _restaurant.currentInQueue;

  List<History> filterQueue(String keyword) {
    //  return currentQueue.where((q)=>q.)
  }
}
