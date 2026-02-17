import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';

class StoreUser extends User {
  final Restaurant rest;
  StoreUser({
    required super.name,
    required super.email,
    required super.phone,
    required super.id,
    required this.rest,
  });
}
