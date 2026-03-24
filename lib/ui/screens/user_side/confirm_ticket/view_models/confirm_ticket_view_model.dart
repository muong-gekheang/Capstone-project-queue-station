import 'dart:async';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/services/queue_service.dart';
import '../../../../../data/repositories/restaurant/restaurant_repository.dart';
import '../../../../../data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class ConfirmTicketViewModel extends ChangeNotifier {
  final QueueEntryRepository queueRepository;
  final RestaurantRepository restaurantRepository;
  final UserProvider userProvider;
  final CustomerRepositoryImpl customerRepository;
  final QueueService queueService;

  ConfirmTicketViewModel({
    required this.queueRepository,
    required this.restaurantRepository,
    required this.userProvider,
    required this.customerRepository,
    required this.queueService,
  });

  List<QueueEntry> currentRestaurantQueue = [];
  StreamSubscription<List<QueueEntry>>? _queueSubscription;

  void listenCurrentRestaurantQueue(String restId) {
    print('listenCurrentRestaurantQueue called for restId: $restId');
    _queueSubscription?.cancel();

    // Use the new method that gets stream for specific restaurant
    _queueSubscription = queueService
        .getQueueStreamForRestaurant(restId)
        .listen(
          (queueList) {
            print(
              'ConfirmTicketViewModel: Received ${queueList.length} queue entries for restaurant $restId',
            );
            currentRestaurantQueue = queueList;

            // Print queue details for debugging
            for (var i = 0; i < queueList.length; i++) {
              print(
                'Queue #${i + 1}: ${queueList[i].id} - ${queueList[i].customerName}',
              );
            }

            notifyListeners();
          },
          onError: (error) {
            print('Queue stream error in ConfirmTicketViewModel: $error');
          },
        );
  }

  int get currentQueueEntriesCount {
    print('currentQueueEntriesCount: ${currentRestaurantQueue.length}');
    return currentRestaurantQueue.length;
  }

  int get customerPosition {
    if (ticket == null) {
      print('No ticket found for position');
      return 0;
    }
    final index = currentRestaurantQueue.indexWhere((q) => q.id == ticket!.id);
    final position = index != -1 ? index + 1 : 0;
    print('Customer position: $position (ticket ID: ${ticket!.id})');
    return position;
  }

  QueueEntry? _ticket;
  QueueEntry? get ticket => _ticket;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  CancelReasonType? cancelReason;
  String? otherReasonText;

  Future<void> loadTicket(String queueEntryId) async {
    print('loadTicket called for ID: $queueEntryId');
    _loading = true;
    notifyListeners();

    try {
      final entry = await queueRepository.getQueueEntryById(queueEntryId);
      print('Queue entry fetched: ${entry?.id}, restId: ${entry?.restId}');

      if (entry == null) {
        _error = "Ticket not found";
        _loading = false;
        notifyListeners();
        return;
      }

      _ticket = entry;
      print(
        'Ticket loaded: ${entry.id}, status: ${entry.status}, restId: ${entry.restId}',
      );

      final rest = await restaurantRepository.getById(entry.restId);
      print('Restaurant fetched: ${rest?.name}');

      if (rest == null) {
        _error = "Restaurant not found";
      } else {
        _restaurant = rest;
        print('Restaurant loaded: ${rest.name}');

        // Start listening to queue updates for this restaurant
        listenCurrentRestaurantQueue(entry.restId);
      }
    } catch (e) {
      _error = e.toString();
      print('Error loading ticket: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Duration> getEstimatedWaitTime() async {
    if (ticket == null) return Duration.zero;

    final avgWaitTime = await queueService.avgWaitingTime;
    print('Average wait time: ${avgWaitTime.inMinutes} minutes');

    if (avgWaitTime.inMinutes == 0) {
      return Duration(minutes: 15);
    }

    final position = customerPosition;
    final waitTimeInMinutes = position * avgWaitTime.inMinutes;
    print(
      'Estimated wait time: $waitTimeInMinutes minutes (position: $position)',
    );

    return Duration(minutes: waitTimeInMinutes);
  }

  Future<bool> cancelQueue() async {
    final customer = userProvider.asCustomer;
    if (customer == null || _ticket == null) {
      print('Cancel failed: customer or ticket is null');
      return false;
    }

    print('Starting cancellation for customer: ${customer.id}');

    try {
      final updatedTicket = _ticket!.copyWith(status: QueueStatus.cancelled);
      await queueRepository.update(updatedTicket);
      print('Queue entry status updated to cancelled');

      await restaurantRepository.removeQueueEntryFromRestaurant(
        _ticket!.restId,
        _ticket!.id,
      );
      print('Queue entry removed from restaurant');

      final updatedCustomer = customer.copyWith(currentHistoryId: null);
      await customerRepository.update(updatedCustomer);
      print('Customer updated in Firestore');

      userProvider.updateUser(updatedCustomer);
      print('UserProvider updated');

      _ticket = updatedTicket;
      notifyListeners();

      return true;
    } catch (e) {
      print('Error cancelling queue: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void setCancelReason(CancelReasonType? reason) {
    cancelReason = reason;
    notifyListeners();
  }

  void setOtherReason(String text) {
    otherReasonText = text;
    cancelReason = CancelReasonType.other;
    notifyListeners();
  }

  @override
  void dispose() {
    _queueSubscription?.cancel();
    super.dispose();
  }
}

enum CancelReasonType { tooLong, changePlan, other }
