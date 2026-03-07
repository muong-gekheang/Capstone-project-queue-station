import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

class RestaurantService {
  Restaurant _restaurant;
  List<QueueEntry> currentQueue = [];

  RestaurantService({required Restaurant restaurant})
    : _restaurant = restaurant {
    currentQueue = _restaurant.currentInQueue;
  }

  Restaurant get restaurant => _restaurant;

  void addQueue(QueueEntry newQueue) {
    currentQueue.add(newQueue);
  }

  void removeQueue(QueueEntry queue) {
    currentQueue.remove(queue);
  }
}
