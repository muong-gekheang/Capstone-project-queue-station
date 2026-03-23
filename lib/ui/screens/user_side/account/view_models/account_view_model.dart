import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';
import '../../../../../data/repositories/restaurant/restaurant_repository.dart';

class AccountViewModel extends ChangeNotifier {
  final UserProvider userProvider;
  final QueueEntryRepository queueRepository;
  final RestaurantRepository restaurantRepository;

  AccountViewModel({
    required this.userProvider,
    required this.queueRepository,
    required this.restaurantRepository,
  });

  Customer? get currentCustomer => userProvider.asCustomer;

  List<QueueEntry> _queueHistory = [];
  List<QueueEntry> get queueHistory => _queueHistory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, Restaurant> _restaurants = {};
  Map<String, Restaurant> get restaurants => _restaurants;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadCustomerData() async {
    final customer = currentCustomer;
    if (customer == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final (history, _) = await queueRepository.getByCustomerId(
        customer.id,
        50,
        null,
      );

      _queueHistory = history;

      // Load restaurant details for each queue entry
      final restaurantIds = history.map((e) => e.restId).toSet();

      for (final restId in restaurantIds) {
        if (!_restaurants.containsKey(restId)) {
          final rest = await restaurantRepository.getById(restId);
          if (rest != null) {
            _restaurants[restId] = rest;
          }
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load account data';
      print('Error loading account data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Restaurant? getRestaurant(String restId) => _restaurants[restId];

  Future<void> refresh() async {
    _restaurants.clear(); // Clear cached restaurants on refresh
    await loadCustomerData();
  }
}
