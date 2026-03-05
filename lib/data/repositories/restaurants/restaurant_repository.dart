import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

abstract class RestaurantRepository {
  Future<void> create(Restaurant restaurant);
  Future<void> delete(String restaurantId);
  Future<Restaurant> update(Restaurant restaurant);
  Future<Restaurant?> getRestaurantById(String restaurantId);
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchRestaurants(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Future<List<Restaurant>> getManyRestaurantsById(List<String> ids);
  Stream<Restaurant> watchCurrentRestaurant();
  Stream<List<Restaurant>> watchAllRestaurant();
}
