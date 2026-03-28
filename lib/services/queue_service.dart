import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';
import 'package:rxdart/rxdart.dart';

class QueueService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  UserProvider _userProvider;
  final QueueEntryRepository _queueEntryRepository;
  final TableService? _tableService; // Make optional for customer view

  List<QueueEntry> queueHistory = [];
  List<QueueEntry> todayFinishedQueue = [];
  DateTime? retrieveAt;

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  StreamSubscription<List<QueueEntry>>? _queueEntrySubscription;
  final _queueEntryStreamController = BehaviorSubject<List<QueueEntry>>.seeded(
    [],
  );

  StreamSubscription<List<QueueEntry>>? _checkedInQueueSubscription;
  final _checkedInQueueController = BehaviorSubject<List<QueueEntry>>.seeded(
    [],
  );

  // For customer view - all active queues
  StreamSubscription<List<QueueEntry>>? _allQueuesSubscription;
  final _allQueuesStreamController = BehaviorSubject<List<QueueEntry>>.seeded(
    [],
  );

  // Cache for restaurant-specific streams
  final Map<String, StreamSubscription<List<QueueEntry>>>
  _restaurantSubscriptions = {};
  final Map<String, BehaviorSubject<List<QueueEntry>>> _restaurantControllers =
      {};

  QueueService({
    required UserProvider userProvider,
    required QueueEntryRepository queueEntryRepository,
    TableService? tableService, // Make optional
  }) : _userProvider = userProvider,
       _queueEntryRepository = queueEntryRepository,
       _tableService = tableService {
    _initStream();
    _listenToAllQueues(); // Add this for customer view
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  void _initStream() {
    // Only listen to specific restaurant queues if user is a store user
    if (_restId.isNotEmpty && _tableService != null) {
      _queueEntrySubscription = _queueEntryRepository
          .watchCurrentActiveQueue(_restId)
          .listen(
            (data) {
              _queueEntryStreamController.add(data);
              _currentEntries = data;
            },
            onError: (error) {
              print("ERROR: $error");
              _queueEntryStreamController.addError(error);
            },
          );

      _checkedInQueueSubscription = _queueEntryRepository
          .watchCurrentInStore(_restId)
          .listen((data) {
            _checkedInQueueController.add(data);
          });
    }
  }

  // Listen to all active queues for customer view
  void _listenToAllQueues() {
    _allQueuesSubscription = _queueEntryRepository
        .watchAllActiveQueues()
        .listen(
          (data) {
            print("QueueService: Received ${data.length} active queues");
            _allQueuesStreamController.add(data);
          },
          onError: (error) {
            print("QueueService all queues error: $error");
            _allQueuesStreamController.addError(error);
          },
        );
  }

  // NEW: Get stream for a specific restaurant
  Stream<List<QueueEntry>> getQueueStreamForRestaurant(String restaurantId) {
    print('QueueService: Getting queue stream for restaurant: $restaurantId');

    // Check if we already have a controller for this restaurant
    if (!_restaurantControllers.containsKey(restaurantId)) {
      // Create a new controller
      final controller = BehaviorSubject<List<QueueEntry>>.seeded([]);
      _restaurantControllers[restaurantId] = controller;

      // Subscribe to repository stream for this restaurant
      final subscription = _queueEntryRepository
          .watchCurrentActiveQueue(restaurantId)
          .listen(
            (data) {
              print(
                'QueueService: Restaurant $restaurantId has ${data.length} waiting entries',
              );
              controller.add(data);
            },
            onError: (error) {
              print('QueueService: Error for restaurant $restaurantId: $error');
              controller.addError(error);
            },
          );

      _restaurantSubscriptions[restaurantId] = subscription;
    }

    return _restaurantControllers[restaurantId]!.stream;
  }

  void dispose() {
    _queueEntrySubscription?.cancel();
    _queueEntryStreamController.close();
    _allQueuesSubscription?.cancel();
    _allQueuesStreamController.close();

    _checkedInQueueController.close();
    _checkedInQueueSubscription?.cancel();
  }

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    final newId = newUserProvider.asStoreUser?.restaurantId ?? "";
    if (newId != _restId && newId.isNotEmpty && _tableService != null) {
      _queueEntrySubscription?.cancel();
      _initStream();
    }
  }

  // For store view - returns queues for specific restaurant
  Stream<List<QueueEntry>> get streamQueueEntries =>
      _queueEntryStreamController.stream;

  // For customer view - returns all active queues
  Stream<List<QueueEntry>> get streamAllActiveQueues =>
      _allQueuesStreamController.stream;

  Stream<List<QueueEntry>> get streamCheckedInQueue =>
      _checkedInQueueController.stream;

  void addCustomerToQueue({required QueueEntry newQueue}) async {
    try {
      HttpsCallable callable = functions.httpsCallable('createQueue');

      final results = await callable.call({
        "customerId": newQueue.restId,
        "id": newQueue.id,
        "joinedMethod": newQueue.joinedMethod.name,
        "orderId": newQueue.orderId,
        "restId": newQueue.restId,
        "partySize": newQueue.partySize,
        "customerName": newQueue.customerName,
        "phoneNumber": newQueue.phoneNumber,
        "queueNumber": newQueue.id.substring(0, 4),
      });

      print("Success! Assigned Queue Number: ${results.data['queueNumber']}");
      print("Estimated Wait: ${results.data['expectedReadyAt']}");
    } on FirebaseFunctionsException catch (e) {
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      print("Details: ${e.details}");
      rethrow;
    } catch (e) {
      print("General Error: $e");
      rethrow;
    }
  }

  void serveCustomer(QueueEntry queueEntry) {
    if (_tableService == null) return;
    _queueEntryRepository.updateStatus(
      queueEntry.id,
      queueEntry.joinedMethod == JoinedMethod.remote
          ? QueueStatus.serving
          : QueueStatus.completed,
    );

    if (queueEntry.joinedMethod != JoinedMethod.walkIn) {
      final table = _tableService.tables.firstWhere(
        (e) => e.id == queueEntry.assignedTableId,
      );
      _tableService.updateTableCustomers(table, queueEntry.id);
    }
  }

  void removeUserFromQueue(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.noShow);
  }

  Future<Duration> get avgWaitingTime async {
    if (_restId.isEmpty) return Duration.zero;

    List<QueueEntry> todayHistory = [];
    if (retrieveAt != null &&
        retrieveAt!.difference(DateTime.now()).abs() <= Duration(minutes: 60) &&
        todayFinishedQueue.isNotEmpty) {
      todayHistory = todayFinishedQueue;
    } else {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      final result = await _queueEntryRepository.getTodayFinishedQueue(_restId);

      todayHistory = result
          .where((e) => e.joinTime.compareTo(startOfToday) >= 0)
          .toList();

      todayFinishedQueue = [...todayHistory];
    }

    int avgMinutes = 0;
    for (var hist in todayHistory) {
      if (hist.servedTime != null) {
        Duration waitTime = hist.joinTime.difference(hist.servedTime!).abs();
        avgMinutes += waitTime.inMinutes;
      }
    }
    if (todayHistory.isNotEmpty) {
      avgMinutes = (avgMinutes / todayHistory.length).round();
    } else {
      avgMinutes = 0;
    }

    return Duration(minutes: avgMinutes);
  }

  Future<bool> retrieveNextQueueHistory() async {
    if (_restId.isEmpty) return false;

    try {
      if (queueHistory.length >= 1000) {
        queueHistory.removeRange(0, 100);
      }
      final result = await _queueEntryRepository.getQueueHistory(
        _restId,
        100,
        lastDoc,
      );
      queueHistory.addAll(result.$1);
      lastDoc = result.$2;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> retrieveQueueHistory(TimeFrameOption timeFrame) async {
    if (_restId.isEmpty) return;

    int limit = (timeFrame == TimeFrameOption.today) ? 100 : 500;

    try {
      final result = await _queueEntryRepository.getQueueHistory(
        _restId,
        limit,
        null,
      );

      final newEntries = result.$1;
      final existingIds = queueHistory.map((e) => e.id).toSet();

      for (var entry in newEntries) {
        if (!existingIds.contains(entry.id)) {
          queueHistory.add(entry);
        }
      }
    } catch (e) {
      print("History Fetch Error: $e");
    }
  }

  List<QueueEntry> _currentEntries = [];

  List<QueueEntry> get currentEntries => List.unmodifiable(_currentEntries);

  int get peopleWaiting {
    int result = 0;
    for (var queue in currentEntries) {
      result += queue.partySize;
    }
    return result;
  }
}
