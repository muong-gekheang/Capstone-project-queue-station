import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/customer_repository_impl.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/user_provider.dart';

class ConfirmTicketViewModel extends ChangeNotifier {
  final QueueEntryRepository queueRepository;
  final RestaurantRepository restaurantRepository;
  final UserProvider userProvider;
  final CustomerRepositoryImpl customerRepository;

  ConfirmTicketViewModel({
    required this.queueRepository,
    required this.restaurantRepository,
    required this.userProvider,
    required this.customerRepository,
  });

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

  /// Fetch ticket and restaurant by queue entry id
  Future<void> loadTicket(String queueEntryId) async {
    _loading = true;
    notifyListeners();

    try {
      final entry = await queueRepository.getQueueEntryById(queueEntryId);
      if (entry == null) {
        _error = "Ticket not found";
        _loading = false;
        notifyListeners();
        return;
      }

      _ticket = entry;
      print('Ticket loaded: ${entry.id}, status: ${entry.status}');

      // Fetch restaurant
      final rest = await restaurantRepository.getById(entry.restId);
      if (rest == null) {
        _error = "Restaurant not found";
      } else {
        _restaurant = rest;
        print('Restaurant loaded: ${rest.name}');
      }
    } catch (e) {
      _error = e.toString();
      print('Error loading ticket: $e');
    }

    _loading = false;
    notifyListeners();
  }

  /// Cancel the queue
  Future<bool> cancelQueue() async {
    final customer = userProvider.asCustomer;
    if (customer == null || _ticket == null) {
      print('Cancel failed: customer or ticket is null');
      return false;
    }

    print('Starting cancellation for customer: ${customer.id}');
    print(
      'Current customer data - currentHistoryId: ${customer.currentHistoryId}',
    );

    try {
      // 1. Update queue entry status to cancelled
      final updatedTicket = _ticket!.copyWith(status: QueueStatus.cancelled);
      await queueRepository.update(updatedTicket);
      print('Queue entry status updated to cancelled');

      // 2. Remove from restaurant's current queue
      await restaurantRepository.removeQueueEntryFromRestaurant(
        _ticket!.restId,
        _ticket!.id,
      );
      print('Queue entry removed from restaurant');

      // 3. Update customer in Firestore - set currentHistoryId to null
      final updatedCustomer = customer.copyWith(
        currentHistoryId: null,
        // noQueue: true, // Keep or remove as needed
      );

      print('Updating customer in Firestore:');
      print('- Old currentHistoryId: ${customer.currentHistoryId}');
      print('- New currentHistoryId: ${updatedCustomer.currentHistoryId}');

      // Save to Firestore using repository
      await customerRepository.update(updatedCustomer);
      print('Customer updated in Firestore');

      // 4. Update local provider state
      userProvider.updateUser(updatedCustomer);
      print('UserProvider updated');

      // 5. Update local ticket state
      _ticket = updatedTicket;

      notifyListeners();

      // Verify the update by fetching fresh data
      final verifyCustomer = await customerRepository.getUserById(customer.id);
      print(
        'Verification - Firestore currentHistoryId: ${verifyCustomer?.currentHistoryId}',
      );

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
}

enum CancelReasonType { tooLong, changePlan, other }
