import 'dart:async';

import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';

class RestaurantService {
  final RestaurantRepository _restaurantRepository;
  final UserProvider _userProvider;

  final StreamController<Restaurant?> _controller =
      StreamController<Restaurant?>.broadcast();

  StreamSubscription<Restaurant?>? _subscription;

  RestaurantService({
    required UserProvider userProvider,
    required RestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository,
       _userProvider = userProvider {
    _initStream();
  }

  String get restId => _userProvider.asStoreUser?.restaurantId ?? "";

  void _initStream() {
    if (restId.isNotEmpty) {
      _subscription = _restaurantRepository
          .watchCurrent(restId)
          .listen(
            (data) => _controller.add(data),
            onError: (error) {
              print("ERROR:$error");
              _controller.addError(error);
            },
          );
    }
  }

  Stream<Restaurant?> get streamRestaurant => _controller.stream;

  StoreUser? get storeUser => _userProvider.asStoreUser;

  void dispose() {
    _subscription?.cancel(); // Kill the Firebase connection immediately
    _controller.close(); // Clean up memory
  }
}
