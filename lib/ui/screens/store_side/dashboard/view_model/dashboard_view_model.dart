import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final TableService _tableService;
  final QueueService _queueService;
  bool _isDisposed = false;

  bool _isLoading = true;
  Duration _avgWaitTime = Duration.zero;

  List<QueueEntry> _currentQueue = [];
  List<QueueTable> _tables = [];

  StreamSubscription<Restaurant?>? _restaurantSubscription;
  StreamSubscription<List<QueueEntry>>? _queueEntriesSubscription;
  StreamSubscription<List<QueueTable>>? _queueTableSubscription;

  DashboardViewModel({
    required QueueService queueService,
    required TableService tableService,
  }) : _queueService = queueService,
       _tableService = tableService {
    _subscribeToQueueEntries();
    _subscribeToQueueTable();
    init();
  }

  void _subscribeToQueueEntries() {
    _queueEntriesSubscription = _queueService.streamQueueEntries.listen(
      (queueEntries) {
        if (_isDisposed) return;
        _currentQueue = queueEntries;
        _isLoading = false;
        init();
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

  void _subscribeToQueueTable() {
    _queueTableSubscription = _tableService.streamQueueTable.listen(
      (tables) {
        if (_isDisposed) return;
        _tables = tables;
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

  void init() async {
    _avgWaitTime = await _queueService.avgWaitingTime;
  }

  @override
  void dispose() {
    _restaurantSubscription?.cancel();
    _queueEntriesSubscription?.cancel();
    _queueTableSubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  bool get isLoading => _isLoading;

  int get queueEntries => _currentQueue.length;

  int get peopleWaiting {
    int result = 0;
    for (QueueEntry queueEntry in _currentQueue) {
      result += queueEntry.partySize;
    }
    return result;
  }

  int get activeTable {
    int result = 0;
    for (var table in _tables) {
      if (table.queueEntryIds.isNotEmpty) {
        result++;
      }
    }
    return result;
  }

  Duration get avgWaitTime => _avgWaitTime;
}
