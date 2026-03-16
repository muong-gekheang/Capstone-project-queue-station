import 'dart:async';

import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository_mock.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class MenuService {
  final MenuItemRepository _menuItemRepository;
  final AddOnRepository _addOnRepository;
  final MenuCategoryRepository _menuCategoryRepository;
  final SizingOptionRepository _sizingOptionRepository;

  UserProvider _userProvider;

  final _addOnController = BehaviorSubject<List<AddOn>>.seeded([]);
  StreamSubscription<List<AddOn>>? _addOnSubscription;

  final _menuItemController = BehaviorSubject<List<MenuItem>>.seeded([]);

  StreamSubscription<List<MenuItem>>? _menuItemSubscription;

  final _menuCategoryController =
      BehaviorSubject<List<MenuItemCategory>>.seeded([]);

  StreamSubscription<List<MenuItemCategory>>? _menuCategorySubscription;

  final _sizeOptionController = BehaviorSubject<List<SizeOption>>.seeded([]);

  StreamSubscription<List<SizeOption>>? _sizeOptionSubscription;

  MenuService({
    required MenuItemRepository menuItemRepository,
    required UserProvider userProvider,
    required MenuCategoryRepository menuCategoryRepository,
    required AddOnRepository addOnRepository,
    required SizingOptionRepository sizingOptionRepository,
  }) : _userProvider = userProvider,
       _menuItemRepository = menuItemRepository,
       _menuCategoryRepository = menuCategoryRepository,
       _addOnRepository = addOnRepository,
       _sizingOptionRepository = sizingOptionRepository {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<MenuItem>> get streamMenuItems => _menuItemController.stream;

  Stream<List<MenuItemCategory>> get streamMenuCategories =>
      _menuCategoryController.stream;

  Stream<List<AddOn>> get streamAddOns => _addOnController.stream;

  Stream<List<SizeOption>> get streamSizeOptions =>
      _sizeOptionController.stream;

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

      _addOnSubscription = _addOnRepository.watchAllAddOn(_restId).listen((
        data,
      ) {
        _addOnController.add(data);
      }, onError: (error) => _addOnController.addError(error));

      _sizeOptionSubscription = _sizingOptionRepository
          .watchAllSizeOptions(_restId)
          .listen((data) {
            _sizeOptionController.add(data);
          }, onError: (error) => _sizeOptionController.addError(error));
    }
  }

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    if (_restId.isNotEmpty) {
      _menuItemSubscription?.cancel();
      _addOnSubscription?.cancel();
      _menuCategorySubscription?.cancel();
      _sizeOptionSubscription?.cancel();
      _initStream();
    }
  }

  void dispose() {
    _menuItemController.close();
    _menuItemSubscription?.cancel();

    _menuCategoryController.close();
    _menuCategorySubscription?.cancel();

    _addOnController.close();
    _addOnSubscription?.cancel();

    _sizeOptionController.close();
    _sizeOptionSubscription?.cancel();
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

  void addAddOn(AddOn newAddOn) {
    newAddOn.restaurantId = _restId;
    _addOnRepository.create(newAddOn);
  }

  void updateAddOn(AddOn newAddOn) {
    _addOnRepository.update(newAddOn);
  }

  void deleteAddOn(AddOn addOn) {
    _addOnRepository.delete(addOn.id);
  }

  void addSizeOption(SizeOption newSizeOption) {
    newSizeOption.restaurantId = _restId;
    _sizingOptionRepository.create(newSizeOption);
  }

  void deleteSizeOption(SizeOption sizeOption) {
    _sizingOptionRepository.delete(sizeOption.id);
  }

  // For Service-to-Service operation
  List<MenuItem> _menuItems = [];
  List<MenuItemCategory> _menuCategories = [];
}
