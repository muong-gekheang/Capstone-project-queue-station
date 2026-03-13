import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';

class QueueService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  UserProvider _userProvider;
  final QueueEntryRepository _queueEntryRepository;
  final TableService _tableService;

  List<QueueEntry> queueHistory = [];
  List<QueueEntry> todayFinishedQueue = [];
  DateTime? retrieveAt;

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  StreamSubscription<List<QueueEntry>>? _queueEntrySubscription;
  final StreamController<List<QueueEntry>> _queueEntryStreamController =
      StreamController<List<QueueEntry>>.broadcast();

  QueueService({
    required UserProvider userProvider,
    required QueueEntryRepository queueEntryRepository,
    required TableService tableService,
  }) : _userProvider = userProvider,
       _queueEntryRepository = queueEntryRepository,
       _tableService = tableService {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  void _initStream() {
    if (_restId.isNotEmpty) {
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
    }
  }

  void dispose() {
    _queueEntrySubscription?.cancel();
    _queueEntryStreamController.close();
  }

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    final newId = newUserProvider.asStoreUser?.restaurantId ?? "";
    if (newId != _restId && newId.isNotEmpty) {
      _queueEntrySubscription?.cancel();
      _initStream();
    }
  }

  // Queue Entry Operations
  Stream<List<QueueEntry>> get streamQueueEntries =>
      _queueEntryStreamController.stream;

  void addCustomerToQueue({required QueueEntry newQueue}) async {
    try {
      // 1. Point to your specific function name
      HttpsCallable callable = functions.httpsCallable('createQueue');

      // 2. Call the function with your data Map
      final results = await callable.call({
        "customerId": newQueue.restId,
        "id": newQueue.id,
        "joinedMethod": newQueue.joinedMethod.name,
        "orderId": newQueue.orderId,
        "restId": newQueue.restId,
        "partySize": newQueue.partySize,
        "customerName": newQueue.customerName,
        "phoneNumber": newQueue.phoneNumber,
        "joinTime": newQueue.joinTime.toIso8601String(),
        "queueNumber": newQueue.id.substring(0, 4),
      });

      // 3. Handle the response (The data returned from your exports.createQueue)
      print("Success! Assigned Queue Number: ${results.data['queueNumber']}");
      print("Estimated Wait: ${results.data['expectedReadyAt']}");
    } on FirebaseFunctionsException catch (e) {
      // This catches the "HttpsError" you threw in Node.js
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      print("Details: ${e.details}");
    } catch (e) {
      print("General Error: $e");
    }
  }

  void serveCustomer(QueueEntry queueEntry) {
    _queueEntryRepository.updateStatus(queueEntry.id, QueueStatus.serving);

    final table = _tableService.tables.firstWhere(
      (e) => e.id == queueEntry.assignedTableId,
    );
    _tableService.updateTableCustomers(table, queueEntry.id);
  }

  void removeUserFromQueue(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.noShow);
  }

  Future<Duration> get avgWaitingTime async {
    List<QueueEntry> todayHistory = [];
    if (retrieveAt != null &&
        retrieveAt!.difference(DateTime.now()).abs() <= Duration(minutes: 60) &&
        todayFinishedQueue.isNotEmpty) {
      todayHistory = todayFinishedQueue;
    } else {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      final result = await _queueEntryRepository.getQueueHistory(
        _restId,
        100,
        null,
      );

      todayHistory = result.$1
          .where((e) => e.joinTime.compareTo(startOfToday) >= 0)
          .toList();

      todayFinishedQueue = [...todayHistory];
    }

    int avgMinutes = 0;
    for (var hist in todayHistory) {
      Duration waitTime = hist.joinTime.difference(hist.servedTime!).abs();
      avgMinutes += waitTime.inMinutes;
    }
    if (todayHistory.isNotEmpty) {
      avgMinutes = (avgMinutes / todayHistory.length).round();
    } else {
      avgMinutes = 0;
    }

    return Duration(minutes: avgMinutes);
  }

  Future<bool> retrieveNextQueueHistory() async {
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

  //(For service-to-service com)
  // 1. Add a local cache
  List<QueueEntry> _currentEntries = [];

  // 2. Add a synchronous getter
  List<QueueEntry> get currentEntries => List.unmodifiable(_currentEntries);

  int get peopleWaiting {
    int result = 0;
    for (var queue in currentEntries) {
      result += queue.partySize;
    }

    return result;
  }
}
