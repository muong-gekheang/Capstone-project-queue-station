import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:uuid/uuid.dart';

class RestaurantRepositoryMock implements RestaurantRepository {
  Map<String, Restaurant> restaurants = {};

  RestaurantRepositoryMock() {
    for (var restaurant in mockRestaurants) {
      restaurants[restaurant.id] = restaurant;
    }
  }

  @override
  Future<Restaurant> create(Restaurant restaurant) {
    // TODO: implement create
    throw UnimplementedError();
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
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Restaurant?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<(List<Restaurant>, DocumentSnapshot<Map<String, dynamic>>?)> search(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<Restaurant> update(Restaurant restaurant) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<Restaurant>> watchAll() {
    // TODO: implement watchAll
    throw UnimplementedError();
  }

  @override
  Stream<Restaurant?> watchCurrent(String restId) {
    return Stream.value(restaurants[restId]!);
  }
}

Uuid uuid = Uuid();
List<Restaurant> mockRestaurants = [
  Restaurant(
    id: uuid.v4(),
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
  ),
  Restaurant(
    id: uuid.v4(),
    name: 'Angle Hai',
    address: "STM St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
  ),
  Restaurant(
    id: uuid.v4(),
    name: 'DoriDori Korean Chicken',
    address: 'AEON MALL SEN SOK',
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
  ),
  Restaurant(
    id: uuid.v4(),
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
  ),
  Restaurant(
    id: uuid.v4(),
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
  ),
];
