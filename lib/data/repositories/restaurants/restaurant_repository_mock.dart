import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/mock_restaurant.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

class RestaurantRepositoryMock implements RestaurantRepository {
  final List<Restaurant> _restaurants = mockRestaurants;
  @override
  Future<void> create(Restaurant restaurant) async{
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String restaurantId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    return (_restaurants.take(limit).toList(), null);
  }

  @override
  Future<List<Restaurant>> getManyRestaurantsById(List<String> ids)async {
    return _restaurants.where((r) => ids.contains(r.id)).toList();
  }

  @override
  Future<Restaurant?> getRestaurantById(String restaurantId) async{
    try {
      return _restaurants.firstWhere((r) => r.id == restaurantId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchRestaurants(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final filtered = _restaurants
        .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return (filtered.take(limit).toList(), null);
  }

  @override
  Future<Restaurant> update(Restaurant restaurant) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<Restaurant>> watchAllRestaurant() async*{
    yield _restaurants;
  }

  @override
  Stream<Restaurant> watchCurrentRestaurant() async*{
    yield _restaurants.first;
  }
}
