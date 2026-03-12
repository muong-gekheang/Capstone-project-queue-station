import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';

class QueueViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService;
  final QueueService _queueService;

  bool _isDisposed = false;

  Restaurant? _currentRestaurant;
  List<QueueEntry> _currentQueue = [];
  bool _isLoading = true;
  Duration _avgWaitTime = Duration.zero;

  StreamSubscription<Restaurant?>? _restaurantSubscription;
  StreamSubscription<List<QueueEntry>>? _queueEntriesSubscription;

  String _searchKeyword = "";

  String get restId => _restaurantService.restId;

  QueueViewModel({
    required RestaurantService restaurantService,
    required QueueService queueService,
  }) : _restaurantService = restaurantService,
       _queueService = queueService {
    _subscribeToRestaurant();
    _subscribeToQueueEntries();
    init();
  }

  void init() async {
    _avgWaitTime = await _queueService.avgWaitingTime;
    if (!_isDisposed) notifyListeners();
  }

  void _subscribeToRestaurant() {
    _restaurantSubscription = _restaurantService.streamRestaurant.listen(
      (restaurant) {
        if (_isDisposed) return;
        _currentRestaurant = restaurant;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _subscribeToQueueEntries() {
    _queueEntriesSubscription = _queueService.streamQueueEntries.listen(
      (queueEntries) {
        if (_isDisposed) return;
        _currentQueue = queueEntries;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    _queueEntriesSubscription?.cancel();
    _isDisposed = true;

    super.dispose();
  }

  bool get isLoading => _isLoading;

  List<QueueEntry> get currentQueue => _currentQueue;

  Duration get avgWaitTime => _avgWaitTime;

  int get biggestTableSize => _currentRestaurant?.biggestTableSize ?? 1;

  DateTime getQueueEstimatedTime(QueueEntry queue) {
    return queue.joinTime.add(avgWaitTime);
  }

  void onSearch(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  List<QueueEntry> get filteredQueue {
    print("QUEUE: ${_currentQueue.length}");
    return currentQueue
        .where(
          (q) => q.customerName!.toLowerCase().startsWith(
            _searchKeyword.toLowerCase(),
          ),
        )
        .toList();
  }

  void addQueue(QueueEntry newQueue) {
    _queueService.addCustomerToQueue(newQueue: newQueue);
    notifyListeners();
  }

  void removeQueue(QueueEntry queue) {
    _queueService.removeUserFromQueue(queue.id);
    notifyListeners();
  }
}
