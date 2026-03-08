import 'dart:async';

import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

// This service is for store side
class RestaurantService {
  final RestaurantRepository _restaurantRepository;
  final QueueTableRepository _queueTableRepository;
  final QueueEntryRepository _queueEntryRepository;
  final UserProvider _userProvider;

  StreamSubscription<Restaurant?>? _restaurantSubscription;
  Stream<Restaurant?>? _restaurantStream;

  RestaurantService({
    required UserProvider userProvider,
    required QueueEntryRepository queueEntryRepository,
    required QueueTableRepository queueTableRepository,
    required RestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository,
       _queueEntryRepository = queueEntryRepository,
       _queueTableRepository = queueTableRepository,
       _userProvider = userProvider;

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<Restaurant?> get streamRestaurant {
    if (_restaurantStream == null){
      _restaurantRepository.watchCurrent(_restId);
    }
    
  }

  Future<List<QueueTable>> get tables async {
    final result = await _queueTableRepository.getAllByRestaurantId(
      _restId,
      1000,
      null,
    );
    return result.$1;
  }

  Future<Duration> get avgWaitingTime async {
    final result = await _queueEntryRepository.getTodayHistory(
      _restId,
      100,
      null,
    );

    List<QueueEntry> todayHistory = result.$1;
    int avgMinutes = 0;
    for (var hist in todayHistory) {
      Duration waitTime = hist.joinTime.difference(hist.servedTime!);
      avgMinutes += waitTime.inMinutes;
    }
    avgMinutes = (avgMinutes / todayHistory.length).round();
    return Duration(minutes: avgMinutes);
  }

  void reset() {
    _restaurantSubscription?.cancel(); // Stop the network connection
    _restaurantSubscription = null; // Clear the memory
    _restaurantStream = null; // Allow a fresh stream to be created later
  }
}
