import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/user_provider.dart';

class RestaurantService {
  final RestaurantRepository _restaurantRepository;
  final UserProvider _userProvider;

  RestaurantService({
    required UserProvider userProvider,
    required RestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository,
       _userProvider = userProvider;

  Stream<Restaurant?> get streamRestaurant =>
      _restaurantRepository.watchCurrent(_userProvider.currentUser?.id ?? "");
}
