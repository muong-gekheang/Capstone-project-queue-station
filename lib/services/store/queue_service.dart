import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class QueueService {
  final UserProvider _userProvider;
  final QueueEntryRepository _queueEntryRepository;

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
  }) : _userProvider = userProvider,
       _queueEntryRepository = queueEntryRepository {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  void _initStream() {
    if (_restId.isNotEmpty) {
      _queueEntrySubscription = _queueEntryRepository
          .watchCurrentActiveQueue(_restId)
          .listen((data) {
            _queueEntryStreamController.add(data);
            _currentEntries = data;
          }, onError: (error) => _queueEntryStreamController.addError(error));
    }
  }

  void dispose() {
    _queueEntrySubscription?.cancel();
    _queueEntryStreamController.close();
  }

  // Queue Entry Operations
  Stream<List<QueueEntry>> get streamQueueEntries =>
      _queueEntryStreamController.stream;

  void addCustomerToQueue({required QueueEntry newQueue}) async {
    _queueEntryRepository.create(newQueue);
  }

  void serveCustomer(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.serving);
  }

  void removeUserFromQueue(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.noShow);
  }

  Future<Duration> get avgWaitingTime async {
    List<QueueEntry> todayHistory = [];
    if (retrieveAt != null &&
        retrieveAt!.difference(DateTime.now()) <= Duration(minutes: 60) &&
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
      Duration waitTime = hist.joinTime.difference(hist.servedTime!);
      avgMinutes += waitTime.inMinutes;
    }
    avgMinutes = (avgMinutes / todayHistory.length).round();

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
