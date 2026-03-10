import 'dart:async';

import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/services/user_provider.dart';

class MenuService {
  final MenuItemRepository _menuItemRepository;
  final UserProvider _userProvider;

  final StreamController<List<MenuItem>> _menuItemController =
      StreamController<List<MenuItem>>.broadcast();

  StreamSubscription<List<MenuItem>>? _menuItemSubscription;

  MenuService({
    required MenuItemRepository menuItemRepository,
    required UserProvider userProvider,
  }) : _userProvider = userProvider,
       _menuItemRepository = menuItemRepository {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<MenuItem>> get streamMenuItems => _menuItemController.stream;

  void _initStream() {
    if (_restId.isNotEmpty) {
      _menuItemSubscription = _menuItemRepository
          .watchAllMenuItem(_restId)
          .listen((data) {
            _menuItemController.add(data);
            _menuItems = data;
          }, onError: (error) => _menuItemController.addError(error));
    }
  }

  void dispose() {
    _menuItemController.close();
    _menuItemSubscription?.cancel();
  }

  void addTable(QueueTable newTable) {}

  void updateMenuItem(MenuItem newMenuItem) {
    _menuItemRepository.update(newMenuItem);
  }

  void deleteTable(QueueTable table) {}

  void addTableCategory(TableCategory newCategory) {}

  void updateTableCategory(TableCategory newCategory) {}

  void deleteTableCategory(TableCategory tableCategory) {}

  // For Service-to-Service operation
  List<MenuItem> _menuItems = [];
}
