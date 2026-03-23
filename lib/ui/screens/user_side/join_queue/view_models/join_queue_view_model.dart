import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';

class JoinQueueViewModel extends ChangeNotifier {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final QueueEntryRepository queueRepository;
  final UserProvider userProvider;
  final RestaurantRepository restaurantRepository;
  final CustomerRepositoryImpl customerRepository;

  JoinQueueViewModel({
    required this.queueRepository,
    required this.userProvider,
    required this.restaurantRepository,
    required this.customerRepository,
  });

  int _numPeople = 0;
  int get numPeople => _numPeople;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  QueueEntry? _createdQueueEntry;
  QueueEntry? get createdQueueEntry => _createdQueueEntry;

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
      // Generate a unique ID for this queue entry
      final queueEntryId = const Uuid().v4();

      print('🔍 STEP 1: Checking Firestore data for restaurant: $restaurantId');

      // Check if restaurant exists
      final restaurantDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .get();
      print('Restaurant exists: ${restaurantDoc.exists}');

      // Check tables
      final tablesQuery = await FirebaseFirestore.instance
          .collection('queue_tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      print('📊 Tables found: ${tablesQuery.docs.length}');
      for (var table in tablesQuery.docs) {
        print('  Table ${table.id}: ${table.data()}');
      }

      // Check categories
      final categoriesQuery = await FirebaseFirestore.instance
          .collection('table_categories')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      print('📊 Categories found: ${categoriesQuery.docs.length}');
      for (var cat in categoriesQuery.docs) {
        print('  Category ${cat.id}: ${cat.data()}');
      }

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
            print(
              '✅ Table ${table.id} can fit $_numPeople people (${minSeat}-${maxSeat})',
            );
            break;
          }
        }
      }

      if (!canFit) {
        throw Exception("No tables can fit $_numPeople people");
      }

      print('🔍 STEP 2: Calling Firebase Function');

      final params = {
        "customerId": customer.id,
        "id": queueEntryId,
        "joinedMethod": JoinedMethod.remote.name,
        "orderId": null,
        "restId": restaurantId,
        "partySize": _numPeople,
        "queueNumber": queueEntryId.substring(0,4),
        "customerName": customer.name,
        "phoneNumber": customer.phone,
      };

      print('📤 Request params: ${jsonEncode(params)}');

      final callable = functions.httpsCallable('createQueue');
      final result = await callable.call(params);

      print('📥 Response: ${result.data}');

      final responseData = result.data as Map<String, dynamic>?;

      if (responseData == null) {
        throw Exception("No data returned from function");
      }

      if (responseData['success'] != true) {
        throw Exception("Function reported failure: ${responseData['error']}");
      }

      print('🔍 STEP 3: Fetching created queue entry');
      final createdEntry = await queueRepository.getQueueEntryById(
        queueEntryId,
      );

      if (createdEntry != null) {
        _createdQueueEntry = createdEntry;
        await _updateCustomerWithQueueEntry(customer, queueEntryId);

        print('✅ Success! Queue Number: ${createdEntry.queueNumber}');
        return createdEntry;
      } else {
        throw Exception("Queue entry created but couldn't be fetched");
      }
    } on FirebaseFunctionsException catch (e) {
      print('❌ FIREBASE FUNCTION ERROR:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      print('  Details: ${e.details}');

      // Try to parse the error message
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
    } catch (e, stackTrace) {
      print('❌ GENERAL ERROR:');
      print('  Error: $e');
      print('  Stack: $stackTrace');
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }

    return null;
  }
  // Using the existing update method from CustomerRepositoryImpl
  Future<void> _updateCustomerWithQueueEntry(
    Customer customer,
    String queueEntryId,
  ) async {
    try {
      // Create an updated customer object with the new queue entry
      final updatedCustomer = Customer(
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        id: customer.id,
        historyIds: [...customer.historyIds, queueEntryId],
        currentHistoryId: queueEntryId,
      );

      print('Updating customer using repository.update()');
      print('  Old historyIds: ${customer.historyIds.length}');
      print('  New historyIds: ${updatedCustomer.historyIds.length}');
      print('  New currentHistoryId: $queueEntryId');

      // Use the existing update method
      await customerRepository.update(updatedCustomer);

      // Update the local UserProvider state
      userProvider.updateUser(updatedCustomer);

      print('Customer updated successfully in Firestore and local state');
    } catch (e) {
      print('Error updating customer: $e');

      // If update fails, try to fetch the latest from Firestore as fallback
      try {
        final freshCustomer = await customerRepository.getUserById(customer.id);
        if (freshCustomer != null) {
          userProvider.updateUser(freshCustomer);
          print('Fallback: Updated from Firestore');
        }
      } catch (fetchError) {
        print('Fallback also failed: $fetchError');
      }

      rethrow;
    }
  }

  String _getUserFriendlyError(String errorMessage) {
    if (errorMessage.contains("No tables match this party size")) {
      return "Sorry, no tables available for $_numPeople people";
    } else if (errorMessage.contains("Missing required fields")) {
      return "System error. Please try again";
    } else if (errorMessage.contains("already has an active queue")) {
      return "You already have an active queue entry";
    } else {
      return "Failed to join queue. Please try again";
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

  // Check if user already has an active queue
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
    } catch (e) {
      print('Error checking active queue: $e');
      return false;
    }
  }
}
