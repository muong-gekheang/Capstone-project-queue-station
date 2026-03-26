// import 'package:queue_station_app/data/repositories/map/restaurant_repository.dart';
// import 'package:queue_station_app/models/restaurant/restaurant.dart';
// import 'package:queue_station_app/data/mock_restaurant.dart'; // Import your dummy data

// class MockRestaurantRepository implements RestaurantRepository {
//   final List<Restaurant> _db = List.from(mockRestaurants);

//   @override
//   Future<List<Restaurant>> getAllRestaurants() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return [..._db];
//   }

//   @override
//   Future<Restaurant?> getRestaurantById(String id) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     try {
//       return _db.firstWhere((r) => r.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<void> addRestaurant(Restaurant restaurant) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _db.add(restaurant);
//   }

//   @override
//   Future<void> updateRestaurant(Restaurant restaurant) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     final index = _db.indexWhere((r) => r.id == restaurant.id);
//     if (index != -1) {
//       _db[index] = restaurant;
//     }
//   }

//   @override
//   Future<void> deleteRestaurantLocation(String id) async {
//     await Future.delayed(const Duration(milliseconds: 300));

//     final index = _db.indexWhere((r) => r.id == id);

//     if (index != -1) {
//       // _db[index].location = null;

//       _db[index] = _db[index].copyWith(location: null);
//     }
//   }
// }
