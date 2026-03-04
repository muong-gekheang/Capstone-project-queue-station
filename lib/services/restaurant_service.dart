import 'package:queue_station_app/models/restaurant/restaurant.dart';

class RestaurantService {
  Restaurant _restaurant;

  RestaurantService({required Restaurant restaurant})
    : _restaurant = restaurant;

  Restaurant get restaurant => _restaurant;
}
