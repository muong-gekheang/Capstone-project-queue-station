import 'package:queue_station_app/models/restaurant/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants();
  Future<Restaurant?> getRestaurantById(String id);
  Future<void> addRestaurant(Restaurant restaurant);
  Future<void> updateRestaurant(Restaurant restaurant);
  Future<void> deleteRestaurantLocation(String id);
}
