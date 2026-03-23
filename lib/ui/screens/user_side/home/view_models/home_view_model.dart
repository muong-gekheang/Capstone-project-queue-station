import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'dart:async';

class HomeViewModel extends ChangeNotifier {
  final RestaurantRepository restaurantRepository;
  final CustomerRepositoryImpl customerRepositoryImpl;
  final UserProvider userProvider;
  final OrderRepository orderRepository;
  final QueueEntryRepository queueEntryRepository;

  HomeViewModel({
    required this.restaurantRepository,
    required this.userProvider,
    required this.orderRepository,
    required this.queueEntryRepository,
    required this.customerRepositoryImpl,
  }) {
    _init();
  }

  @override
  void dispose() {
    _restaurantSub?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    listenToRestaurants();

    // After user is loaded, load their queue if they have one
    if (user != null && user!.currentHistoryId != null) {
      await loadCurrentQueue();
    }
  }

  StreamSubscription<List<Restaurant>>? _restaurantSub;

  Customer? get user => userProvider.asCustomer;
  QueueEntry? _currentQueueEntry;
  QueueEntry? get currentQueueEntry => _currentQueueEntry;

  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToRestaurants() {
    _isLoading = true;
    notifyListeners();

    _restaurantSub = restaurantRepository.watchAll().listen(
      (data) {
        _allRestaurants = data;
        _restaurants = data;
        _isLoading = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = 'Failed to load restaurants';
        notifyListeners();
      },
    );
  }

  Future<void> loadRestaurants() async {
    try {
      _isLoading = true;
      notifyListeners();

      final (data, _) = await restaurantRepository.getAll(20, null);
      _allRestaurants = data;
      _restaurants = data;
      _errorMessage = null;
    } catch (e) {
      print('Error loading restaurants: $e');
      _errorMessage = 'Failed to load restaurants';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get shouldShowJoinedTile {
    if (user == null ||
        currentQueueEntry == null ||
        currentRestaurant == null) {
      return false;
    }

    // Only show if user has current history AND queue status is waiting
    return user!.currentHistoryId != null &&
        currentQueueEntry!.status == QueueStatus.waiting;
  }

  Future<void> loadCurrentQueue() async {
    if (user == null) {
      print('Cannot load queue: user is null');
      return;
    }

    try {
      print('Loading current queue for user: ${user!.id}');
      _currentQueueEntry = await queueEntryRepository.getCurrentByCustomerId(
        user!.id,
      );
      print('Queue loaded: ${_currentQueueEntry != null}');
    } catch (e) {
      print('Error loading current queue: $e');
    } finally {
      notifyListeners();
    }
  }

  List<Restaurant> get filteredRestaurants {
    // Exclude the current restaurant only if joined tile should show
    if (!shouldShowJoinedTile) return _restaurants;

    return _restaurants
        .where((r) => r.id != currentQueueEntry!.restId)
        .toList();
  }

  Restaurant? get currentRestaurant {
    if (_currentQueueEntry == null) return null;

    try {
      return _allRestaurants.firstWhere(
        (r) => r.id == _currentQueueEntry!.restId,
      );
    } catch (e) {
      return null;
    }
  }

  void searchRestaurants(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      _restaurants = [..._allRestaurants];
    } else {
      _restaurants = _allRestaurants.where((r) {
        final name = r.name.toLowerCase();
        final address = (r.address ?? '').toLowerCase();
        return name.contains(lowerQuery) || address.contains(lowerQuery);
      }).toList();
    }

    notifyListeners();
  }

  void resetSearch() {
    _restaurants = [..._allRestaurants];
    notifyListeners();
  }

  Future<void> refresh() async {
    if (user != null && user!.currentHistoryId != null) {
      await loadCurrentQueue();
    }
  }
}
