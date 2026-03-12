import 'dart:async';

import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/services/user_provider.dart';

class MenuService {
  final MenuItemRepository _menuItemRepository;
  final MenuCategoryRepository _menuCategoryRepository;
  final UserProvider _userProvider;

  final StreamController<List<MenuItem>> _menuItemController =
      StreamController<List<MenuItem>>.broadcast();

  StreamSubscription<List<MenuItem>>? _menuItemSubscription;

  final StreamController<List<MenuItemCategory>> _menuCategoryController =
      StreamController<List<MenuItemCategory>>.broadcast();

  StreamSubscription<List<MenuItemCategory>>? _menuCategorySubscription;

  MenuService({
    required MenuItemRepository menuItemRepository,
    required UserProvider userProvider,
    required MenuCategoryRepository menuCategoryRepository,
  }) : _userProvider = userProvider,
       _menuItemRepository = menuItemRepository,
       _menuCategoryRepository = menuCategoryRepository {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<MenuItem>> get streamMenuItems => _menuItemController.stream;

  Stream<List<MenuItemCategory>> get streamMenuCategories =>
      _menuCategoryController.stream;

  void _initStream() {
    if (_restId.isNotEmpty) {
      _menuItemSubscription = _menuItemRepository
          .watchAllMenuItem(_restId)
          .listen(
            (data) {
              _menuItemController.add(data);
              _menuItems = data;
            },
            onError: (error) {
              print("ERROR:$error");
              _menuItemController.addError(error);
            },
          );

      _menuCategorySubscription = _menuCategoryRepository
          .watchAllMenuCategory(_restId)
          .listen((data) {
            _menuCategoryController.add(data);
            _menuCategories = data;
          }, onError: (error) => _menuItemController.addError(error));
    }
  }

  void dispose() {
    _menuItemController.close();
    _menuItemSubscription?.cancel();

    _menuCategoryController.close();
    _menuCategorySubscription?.cancel();
  }

  void addMenuItem(MenuItem newMenu) {
    _menuItemRepository.create(newMenu);
  }

  void updateMenuItem(MenuItem newMenuItem) {
    _menuItemRepository.update(newMenuItem);
  }

  void deleteMenuItem(MenuItem menuItem) {
    _menuItemRepository.delete(menuItem.id);
  }

  void addMenuCategory(MenuItemCategory newCategory) {
    _menuCategoryRepository.create(newCategory);
  }

  void updateMenuCategory(MenuItemCategory newCategory) {
    _menuCategoryRepository.update(newCategory);
  }

  void deleteMenuCategory(MenuItemCategory menuCategory) {
    _menuCategoryRepository.delete(menuCategory.id);
  }

  // For Service-to-Service operation
  List<MenuItem> _menuItems = [];
  List<MenuItemCategory> _menuCategories = [];
}
