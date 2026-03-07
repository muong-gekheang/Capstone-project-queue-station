import 'package:flutter/material.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/restaurant_service.dart';

class QueueViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  String _searchKeyword = "";

  QueueViewModel({required RestaurantService restaurantService})
    : _restaurantService = restaurantService;

  List<QueueEntry> get currentQueue => _restaurantService.currentQueue;

  Duration get avgWaitTime => _restaurantService.restaurant.averageWaitingTime;

  int get biggestTableSize => _restaurantService.restaurant.biggestTableSize;

  DateTime getQueueEstimatedTime(QueueEntry queue) {
    return queue.joinTime.add(avgWaitTime);
  }

  void onSearch(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  List<QueueEntry> get filteredQueue {
    return currentQueue
        .where(
          (q) => q.customerName!.toLowerCase().startsWith(
            _searchKeyword.toLowerCase(),
          ),
        )
        .toList();
  }

  void addQueue(QueueEntry newQueue) {
    _restaurantService.addQueue(newQueue);
    notifyListeners();
  }

  void removeQueue(QueueEntry queue) {
    _restaurantService.removeQueue(queue);
    notifyListeners();
  }
}
