import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class JoinQueueViewModel extends ChangeNotifier {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final QueueEntryRepository queueRepository;
  final UserProvider userProvider;
  final RestaurantRepository restaurantRepository;
  final CustomerRepositoryImpl customerRepository;
  final QueueService queueService;

  // State variables
  int _numPeople = 0;
  int get numPeople => _numPeople;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  QueueEntry? _createdQueueEntry;
  QueueEntry? get createdQueueEntry => _createdQueueEntry;

  // Real-time queue data
  List<QueueEntry> _currentQueueEntries = [];
  List<QueueEntry> get currentQueueEntries => _currentQueueEntries;

  int _queueCount = 0;
  int get queueCount => _queueCount;

  int _peopleWaiting = 0;
  int get peopleWaiting => _peopleWaiting;

  Duration _averageWaitTime = Duration.zero;
  Duration get averageWaitTime => _averageWaitTime;

  bool _isLoadingAvgWaitTime = true;
  bool get isLoadingAvgWaitTime => _isLoadingAvgWaitTime;

  StreamSubscription<List<QueueEntry>>? _queueSubscription;

  JoinQueueViewModel({
    required this.queueRepository,
    required this.userProvider,
    required this.restaurantRepository,
    required this.customerRepository,
    required this.queueService,
  });

  // Start listening to real-time queue updates for a restaurant
  void startListeningToQueue(String restaurantId) async {
    print(
      'JoinQueueViewModel: Starting to listen to queue for restaurant: $restaurantId',
    );
    _queueSubscription?.cancel();

    // Load average wait time first
    await _loadAverageWaitTime();

    _queueSubscription = queueService
        .getQueueStreamForRestaurant(restaurantId)
        .listen(
          (queueEntries) {
            print(
              'JoinQueueViewModel: Received ${queueEntries.length} queue entries',
            );
            _currentQueueEntries = queueEntries;
            _queueCount = queueEntries.length;

            // Calculate total people waiting (sum of party sizes)
            _peopleWaiting = queueEntries.fold(
              0,
              (sum, entry) => sum + entry.partySize,
            );

            print('Queue count: $_queueCount, People waiting: $_peopleWaiting');
            notifyListeners();
          },
          onError: (error) {
            print('Queue stream error in JoinQueueViewModel: $error');
          },
        );
  }

  Future<void> _loadAverageWaitTime() async {
    _isLoadingAvgWaitTime = true;
    notifyListeners();

    try {
      _averageWaitTime = await queueService.avgWaitingTime;
      print('Average wait time loaded: ${_averageWaitTime.inMinutes} minutes');
    } catch (e) {
      print('Error loading average wait time: $e');
      _averageWaitTime = Duration(minutes: 15); // Default fallback
    } finally {
      _isLoadingAvgWaitTime = false;
      notifyListeners();
    }
  }

  void stopListening() {
    _queueSubscription?.cancel();
  }

  // Get estimated wait time for new joiner using average wait time
  int getEstimatedWaitTime() {
    if (_isLoadingAvgWaitTime) {
      return 0; // Still loading
    }

    // They will be at the end of the queue
    final position = _queueCount + 1;
    final avgMinutes = _averageWaitTime.inMinutes;

    if (avgMinutes == 0) {
      // Fallback to 15 minutes if no historical data
      return position * 15;
    }

    return position * avgMinutes;
  }

  // Get formatted estimated wait time
  String getFormattedEstimatedWaitTime() {
    final minutes = getEstimatedWaitTime();
    if (minutes <= 0) return "Calculating...";
    if (minutes < 60) return "$minutes min";
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return "$hours hour${hours > 1 ? 's' : ''}";
    }
    return "$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min";
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setNumPeople(int value) {
    _numPeople = value;
    notifyListeners();
  }

  void incrPeople(int maxSeats) {
    _numPeople = min(_numPeople + 1, maxSeats);
    notifyListeners();
  }

  void decrPeople() {
    _numPeople = max(_numPeople - 1, 0);
    notifyListeners();
  }

  void reset() {
    _numPeople = 0;
    _errorMessage = null;
    _createdQueueEntry = null;
    notifyListeners();
  }

  Future<QueueEntry?> joinQueue(String restaurantId) async {
    final customer = userProvider.asCustomer;

    if (customer == null) {
      _errorMessage = "No user logged in";
      notifyListeners();
      return null;
    }

    if (_numPeople <= 0) {
      _errorMessage = "Please select number of people";
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final queueEntryId = const Uuid().v4();

      // Check if restaurant exists
      final restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (!restaurantDoc.exists) {
        throw Exception("Restaurant not found");
      }

      // Check tables
      final tablesQuery = await FirebaseFirestore.instance
          .collection('queue_tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      // Check categories
      final categoriesQuery = await FirebaseFirestore.instance
          .collection('table_categories')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      if (tablesQuery.docs.isEmpty) {
        throw Exception("No queue_tables found for this restaurant");
      }

      if (categoriesQuery.docs.isEmpty) {
        throw Exception("No tableCategories found for this restaurant");
      }

      // Check if any table can fit the party size
      bool canFit = false;
      final categoryMap = <String, Map<String, dynamic>>{};
      for (var cat in categoriesQuery.docs) {
        categoryMap[cat.id] = cat.data();
      }

      for (var table in tablesQuery.docs) {
        final tableData = table.data();
        final categoryId = tableData['tableCategoryId'];
        final category = categoryMap[categoryId];

        if (category != null) {
          final minSeat = category['minSeat'] ?? 0;
          final maxSeat = category['seatAmount'] ?? 100;
          if (_numPeople >= minSeat && _numPeople <= maxSeat) {
            canFit = true;
            break;
          }
        }
      }

      if (!canFit) {
        throw Exception("No tables can fit $_numPeople people");
      }

      // Call Firebase Function
      final params = {
        "customerId": customer.id,
        "id": queueEntryId,
        "joinedMethod": JoinedMethod.remote.name,
        "orderId": null,
        "restId": restaurantId,
        "partySize": _numPeople,
        "queueNumber": queueEntryId.substring(0, 4),
        "customerName": customer.name,
        "phoneNumber": customer.phone,
      };

      final callable = functions.httpsCallable('createQueue');
      final result = await callable.call(params);

      final responseData = result.data as Map<String, dynamic>?;

      if (responseData == null) {
        throw Exception("No data returned from function");
      }

      if (responseData['success'] != true) {
        throw Exception("Function reported failure: ${responseData['error']}");
      }

      // Fetch the created queue entry
      final createdEntry = await queueRepository.getQueueEntryById(
        queueEntryId,
      );

      if (createdEntry != null) {
        _createdQueueEntry = createdEntry;
        await _updateCustomerWithQueueEntry(customer, queueEntryId);
        return createdEntry;
      } else {
        throw Exception("Queue entry created but couldn't be fetched");
      }
    } on FirebaseFunctionsException catch (e) {
      if (e.message != null) {
        if (e.message!.contains("No tables match this party size")) {
          _errorMessage = "No tables available for $_numPeople people";
        } else if (e.message!.contains("No tables found")) {
          _errorMessage = "This restaurant has no tables configured";
        } else if (e.message!.contains("No table categories")) {
          _errorMessage = "Restaurant configuration error";
        } else {
          _errorMessage = "Queue service error: ${e.message}";
        }
      } else {
        _errorMessage = "Failed to join queue";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }

    return null;
  }

  Future<void> _updateCustomerWithQueueEntry(
    Customer customer,
    String queueEntryId,
  ) async {
    try {
      final updatedCustomer = Customer(
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        id: customer.id,
        historyIds: [...customer.historyIds, queueEntryId],
        currentHistoryId: queueEntryId,
      );

      await customerRepository.update(updatedCustomer);
      userProvider.updateUser(updatedCustomer);
    } catch (e) {
      try {
        final freshCustomer = await customerRepository.getUserById(customer.id);
        if (freshCustomer != null) {
          userProvider.updateUser(freshCustomer);
        }
      } catch (_) {}
      rethrow;
    }
  }

  String formattedPhone(String phone) {
    if (phone.length >= 6) {
      return phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d{3})(\d+)"),
        (match) => "${match[1]} ${match[2]} ${match[3]}",
      );
    } else {
      return phone;
    }
  }

  Future<bool> hasActiveQueue() async {
    final customer = userProvider.asCustomer;
    if (customer == null || customer.currentHistoryId == null) {
      return false;
    }

    try {
      final queueEntry = await queueRepository.getQueueEntryById(
        customer.currentHistoryId!,
      );
      return queueEntry != null && queueEntry.status == QueueStatus.waiting;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
