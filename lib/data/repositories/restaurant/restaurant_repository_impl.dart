import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final FirebaseFirestore fireStore;

  RestaurantRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<Restaurant> create(Restaurant restaurant) async {
    final restaurantRef = fireStore
        .collection('restaurants')
        .doc(restaurant.id);
    final restaurantJson = Map<String, dynamic>.from(restaurant.toJson());
    await restaurantRef.set(restaurantJson);

    return restaurant;
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    Query<Map<String, dynamic>> query = fireStore
        .collection('restaurants')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final snap = await query.get();
    final restaurants = snap.docs.map((res) {
      final json = Map<String, dynamic>.from(res.data());
      json['id'] ??= res.id;
      return Restaurant.fromJson(json);
    }).toList();

    final nextCursor = snap.docs.isEmpty ? null : snap.docs.last;
    return (restaurants, nextCursor);
  }

  @override
  Future<Restaurant?> getById(String id) async {
    final docRef = fireStore.collection('restaurants').doc(id);
    final doc = await docRef.get();

    if (!doc.exists) return null;
    final json = Map<String, dynamic>.from(doc.data()!);
    json['id'] ??= doc.id;
    return Restaurant.fromJson(json);
  }

  @override
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> search(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) async {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return getAll(limit, lastDoc);
    }

    final matchedRestaurants = <Restaurant>[];
    DocumentSnapshot<Map<String, dynamic>>? cursor = lastDoc;
    final batchSize = limit <= 0 ? 20 : limit * 3;

    while (matchedRestaurants.length < limit) {
      Query<Map<String, dynamic>> firestoreQuery = fireStore
          .collection('restaurants')
          .orderBy('name')
          .limit(batchSize);

      if (cursor != null) {
        firestoreQuery = firestoreQuery.startAfterDocument(cursor);
      }

      final snap = await firestoreQuery.get();
      if (snap.docs.isEmpty) {
        cursor = null;
        break;
      }

      for (final doc in snap.docs) {
        final json = Map<String, dynamic>.from(doc.data());
        final name = (json['name'] as String? ?? '').toLowerCase();
        final address = (json['address'] as String? ?? '').toLowerCase();
        final phone = (json['phone'] as String? ?? '').toLowerCase();
        final isMatch =
            name.contains(searchQuery) ||
            address.contains(searchQuery) ||
            phone.contains(searchQuery);

        if (!isMatch) continue;

        json['id'] ??= doc.id;
        matchedRestaurants.add(Restaurant.fromJson(json));
        if (matchedRestaurants.length >= limit) break;
      }

      cursor = snap.docs.last;
      if (snap.docs.length < batchSize) {
        cursor = null;
        break;
      }
    }

    return (matchedRestaurants, cursor);
  }

  @override
  Future<Restaurant> update(Restaurant restaurant) async {
    final restaurantRef = fireStore
        .collection('restaurants')
        .doc(restaurant.id);
    final restaurantJson = Map<String, dynamic>.from(restaurant.toJson());

    await restaurantRef.update(restaurantJson);
    return restaurant;
  }

  @override
  Stream<List<Restaurant>> watchAll() {
    // TODO: implement watchAll
    throw UnimplementedError();
  }

  @override
  Stream<Restaurant?> watchCurrent(String id) {
    return fireStore
        .collection('restaurants')
        .where('id', isEqualTo: id)
        .snapshots()
        .handleError((err) => debugPrint("$err"))
        .map((snap) {
          if (snap.docs.isEmpty) return null; // Handle not found

          final doc = snap.docs.first; // Get the first match
          final json = Map<String, dynamic>.from(doc.data());
          json['id'] ??= doc.id;

          return Restaurant.fromJson(json);
        });
  }
}
