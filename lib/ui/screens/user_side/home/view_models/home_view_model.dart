import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/restaurants_service.dart';
import 'package:queue_station_app/services/user_provider.dart';

class HomeViewModel extends ChangeNotifier {
  final RestaurantListService restaurantService;
  final QueueService queueService;
  final UserProvider userProvider;

  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _restaurants = [];
  final Map<String, int> _peopleWaiting = {};
  QueueEntry? _currentQueue;

  bool _isLoading = true;
  String? _errorMessage;

  List<Restaurant> get restaurants => _restaurants;
  Map<String, int> get peopleWaitingPerRestaurant => _peopleWaiting;
  QueueEntry? get currentQueueEntry => _currentQueue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeViewModel({
    required this.restaurantService,
    required this.queueService,
    required this.userProvider,
  }) {
    _init();
  }

  void _init() {
    // Subscribe to restaurant updates
    restaurantService.streamRestaurants.listen(
      (data) {
        debugPrint('HomeViewModel: Received ${data.length} restaurants');
        _allRestaurants = data;
        _restaurants = List.from(data);
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Restaurant stream error: $e');
        _errorMessage = 'Failed to load restaurants';
        _isLoading = false;
        notifyListeners();
      },
    );

    // Subscribe to ALL active queues for customer view
    queueService.streamAllActiveQueues.listen(
      (data) {
        debugPrint('HomeViewModel: Received ${data.length} queue entries');

        // Update waiting counts per restaurant
        _peopleWaiting.clear();
        for (var q in data) {
          _peopleWaiting[q.restId] = (_peopleWaiting[q.restId] ?? 0) + 1;
        }

        // Find current user's queue entry
        final customerId = userProvider.asCustomer?.id;
        if (customerId != null) {
          _currentQueue = data.firstWhereOrNull(
            (q) => q.customerId == customerId,
          );
        } else {
          _currentQueue = null;
        }

        debugPrint('Current queue entry: ${_currentQueue?.id}');
        debugPrint('People waiting counts: $_peopleWaiting');
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Queue stream error: $e');
      },
    );
  }

  bool get shouldShowJoinedTile =>
      _currentQueue != null && _currentQueue!.status == QueueStatus.waiting;

  Restaurant? get currentRestaurant {
    if (_currentQueue == null) return null;
    return _allRestaurants.firstWhereOrNull(
      (r) => r.id == _currentQueue!.restId,
    );
  }

  List<Restaurant> get filteredRestaurants {
    if (!shouldShowJoinedTile) return _restaurants;
    return _restaurants.where((r) => r.id != _currentQueue?.restId).toList();
  }

  void searchRestaurants(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      _restaurants = List.from(_allRestaurants);
    } else {
      _restaurants = _allRestaurants
          .where(
            (r) =>
                r.name.toLowerCase().contains(lowerQuery) ||
                r.address.toLowerCase().contains(lowerQuery),
          )
          .toList();
    }

    notifyListeners();
  }

  void resetSearch() {
    _restaurants = List.from(_allRestaurants);
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    // Force refresh by re-triggering
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }

}
