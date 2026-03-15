import 'dart:async';

import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantService {
  final RestaurantRepository _restaurantRepository;
  UserProvider _userProvider;

  final _controller = BehaviorSubject<Restaurant?>.seeded(null);

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
            (data) {
              print("Data:${data?.isOpen}");
              _controller.add(data);
              _currentRest = data;
            },
            onError: (error) {
              print("ERROR:$error");
              _controller.addError(error);
            },
          );
    }
  }

  Stream<Restaurant?> get streamRestaurant => _controller.stream;

  void updateStoreStatus(bool isOpen) {
    if (_currentRest != null) {
      _restaurantRepository.update(_currentRest!.copyWith(isOpen: isOpen));
    }
  }

  StoreUser? get storeUser => _userProvider.asStoreUser;

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    final newId = newUserProvider.asStoreUser?.restaurantId ?? "";
    if (newId != restId && newId.isNotEmpty) {
      _subscription?.cancel();
      _initStream();
    }
  }

  void dispose() {
    _controller.close();
    _subscription?.cancel();
  }

  Restaurant? _currentRest;
  Restaurant? get currentRest => _currentRest;
}
