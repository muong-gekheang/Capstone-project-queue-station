import 'dart:async';

import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class MenuService {
  final MenuItemRepository _menuItemRepository;
  final MenuCategoryRepository _menuCategoryRepository;
  UserProvider _userProvider;

  final _menuItemController = BehaviorSubject<List<MenuItem>>.seeded([]);

  StreamSubscription<List<MenuItem>>? _menuItemSubscription;

  final _menuCategoryController =
      BehaviorSubject<List<MenuItemCategory>>.seeded([]);

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

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    if (_restId.isNotEmpty) {
      _menuItemSubscription?.cancel();
      _menuCategorySubscription?.cancel();
      _initStream();
    }
  }

  void dispose() {
    _menuItemController.close();
    _menuItemSubscription?.cancel();

    _menuCategoryController.close();
    _menuCategorySubscription?.cancel();
  }

  void addMenuItem(MenuItem newMenu) {
    MenuItem menuToAdd = newMenu.copyWith(restaurantId: _restId);
    _menuItemRepository.create(menuToAdd);
  }

  void updateMenuItem(MenuItem newMenuItem) {
    _menuItemRepository.update(newMenuItem);
  }

  void deleteMenuItem(MenuItem menuItem) {
    _menuItemRepository.delete(menuItem.id);
  }

  void addMenuCategory(MenuItemCategory newCategory) {
    newCategory.restaurantId = _restId;
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
