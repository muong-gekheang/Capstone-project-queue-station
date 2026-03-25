import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class RestaurantListService {
  final RestaurantRepository _restaurantRepository;

  final _controller = BehaviorSubject<List<Restaurant>>.seeded([]);

  Stream<List<Restaurant>> get streamRestaurants => _controller.stream;

  StreamSubscription<List<Restaurant>>? _subscription;

  RestaurantListService(this._restaurantRepository) {
    _initStream();
  }

  void _initStream() {
    _subscription = _restaurantRepository.watchAll().listen(
      (restaurants) {
        _controller.add(restaurants);
      },
      onError: (e) {
        _controller.addError('Failed to load restaurants: $e');
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
