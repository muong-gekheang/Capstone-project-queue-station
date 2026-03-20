import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

abstract class RestaurantRepository {
  Future<Restaurant> create(Restaurant restaurant);
  Future<void> delete(String id);
  Future<Restaurant> update(Restaurant restaurant);
  Future<Restaurant?> getById(String id);
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> search(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );

  Future<void> addQueueEntryToRestaurant(
    String restaurantId,
    String queueEntryId,
  );

  Future<void> removeQueueEntryFromRestaurant(
    String restaurantId,
    String queueEntryId,
  );

  Stream<Restaurant> watchCurrent(String id);
  Stream<List<Restaurant>> watchAll();
}
