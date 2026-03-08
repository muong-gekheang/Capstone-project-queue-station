import 'dart:io';

import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';

class StoreProfileService {
  final UserProvider _userProvider;
  final UserRepository<StoreUser> _userRepository;

  StoreUser? get storeUser => _userProvider.asStoreUser;

  StoreProfileService({
    required UserProvider userProvider,
    required UserRepository<StoreUser> userRepository,
  }) : _userProvider = userProvider,
       _userRepository = userRepository;

  void setStoreProfileImage(File? image) {} // TODO: HOw do we store image

  void setStoreName(String name) {
    _userProvider.updateUser(storeUser?.copyWith(name: name));
    final storeUserTemp = storeUser;
    if (storeUserTemp != null) {
      _userRepository.update(storeUserTemp);
    }
  }
}
