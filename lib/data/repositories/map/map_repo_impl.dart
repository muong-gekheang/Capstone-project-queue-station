import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/map/map_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

class MapRepositoryImpl implements MapRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // The name of collection in Firebase
  final String _collectionPath = 'restaurants';

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure the Firebase Document ID is set as the Restaurant ID
        data['id'] = doc.id;
        return Restaurant.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error fetching all restaurants: $e");
      return [];
    }
  }

  @override
  Stream<List<Restaurant>> getRestaurantsStream() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Restaurant.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<Restaurant?> getRestaurantById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Restaurant.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Error fetching restaurant by ID: $e");
      return null;
    }
  }

  @override
  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(restaurant.id)
          .set(restaurant.toJson());
    } catch (e) {
      print("Error adding restaurant: $e");
    }
  }

  @override
  Future<void> updateRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(restaurant.id)
          .update(restaurant.toJson());
    } catch (e) {
      print("Error updating restaurant: $e");
    }
  }

  @override
  Future<void> deleteRestaurantLocation(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update({
        'location': null,
      });
    } catch (e) {
      print("Error deleting restaurant location: $e");
    }
  }

  // @override
  // Stream<List<Restaurant>> getRestaurantsStream() {
  //   // TODO: implement getRestaurantsStream
  //   throw UnimplementedError();
  // }
}
