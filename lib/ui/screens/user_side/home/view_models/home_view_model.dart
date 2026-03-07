import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

class HomeViewModel extends ChangeNotifier {
  final RestaurantRepository restaurantRepository;
  final OrderRepository orderRepository;

  HomeViewModel({
    required this.restaurantRepository,
    required this.orderRepository
  });

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadRestaurants() async {
    _isLoading = true;
    notifyListeners();

    final (data, _) = await restaurantRepository.getAll(20, null);

    _restaurants = data;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      await loadRestaurants();
      return;
    }

    final (data, _) = await restaurantRepository.getSearchRestaurants(
      query,
      20,
      null,
    );

    _restaurants = data;
    notifyListeners();
  }
}
