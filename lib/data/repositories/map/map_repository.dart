import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

abstract class MapRepository {
  Future<List<Restaurant>> getAllRestaurants();
  Stream<List<Restaurant>> getRestaurantsStream();
  Future<Restaurant?> getRestaurantById(String id);
  Future<void> addRestaurant(Restaurant restaurant);
  Future<void> updateRestaurant(Restaurant restaurant);
  Future<void> deleteRestaurantLocation(String id);
}
