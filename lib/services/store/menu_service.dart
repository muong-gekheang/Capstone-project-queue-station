import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class MenuService {
  final MenuItemRepository _menuItemRepository;
  final AddOnRepository _addOnRepository;
  final MenuCategoryRepository _menuCategoryRepository;
  final SizingOptionRepository _sizingOptionRepository;
  final MenuSizeRepository _menuSizeRepository;
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
    required MenuSizeRepository menuSizeRepository,
  }) : _userProvider = userProvider,
       _menuItemRepository = menuItemRepository,
       _menuCategoryRepository = menuCategoryRepository,
       _addOnRepository = addOnRepository,
       _sizingOptionRepository = sizingOptionRepository,
       _menuSizeRepository = menuSizeRepository {
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
              _menuItemsMap = {
                for (var menuItem in data) menuItem.id: menuItem,
              };
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
            _sizeOptions = data;
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

  Future<MenuItem?> getMenuItemById(String menuItemId) async {
    return await _menuItemRepository.getMenuItemById(menuItemId);
  }

  Future<MenuItem> getMenuItemDetails(MenuItem menuItem) async {
    final List<MenuSize> menuSizes = [];
    final List<AddOn> addOns = [];
    for (var menuSizeId in menuItem.menuSizeOptionIds) {
      var result = await _menuSizeRepository.getMenuSizeById(menuSizeId);
      if (result != null) {
        result.sizeOption = _sizeOptions.firstWhere(
          (e) => e.id == result.sizeOptionId,
        );
        menuSizes.add(result);
      }
    }

    for (var addOnId in menuItem.addOnIds) {
      var result = await _addOnRepository.getAddOnById(addOnId);
      if (result != null) addOns.add(result);
    }
    final result = menuItem.copyWith(sizes: menuSizes, addOns: addOns);
    return result;
  }

  void addMenuItem(MenuItem newMenu) {
    MenuItem menuToAdd = newMenu.copyWith(restaurantId: _restId);
    _menuItemRepository.create(menuToAdd);
    for (var menuSize in newMenu.sizes) {
      _menuSizeRepository.create(menuSize);
    }
  }

  Future<void> updateMenuItem(
    MenuItem newMenuItem,
    MenuItem? oldMenuItem,
  ) async {
    newMenuItem = newMenuItem.copyWith(restaurantId: _restId);
    oldMenuItem = oldMenuItem?.copyWith(restaurantId: _restId);
    if (oldMenuItem != null) {
      final batch = FirebaseFirestore.instance.batch();

      // 1. Get references instead of calling 'update' directly
      final itemRef = FirebaseFirestore.instance
          .collection('menu_items')
          .doc(newMenuItem.id);
      batch.set(itemRef, newMenuItem.toJson(), SetOptions(merge: true));

      final newSizeSet = newMenuItem.sizes.toSet();
      final oldSizeSet = oldMenuItem.sizes.toSet();

      // 2. Add all operations to the SAME batch
      // Create new ones
      for (var menuSize in newSizeSet.difference(oldSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.set(ref, menuSize.toJson());
      }

      // Delete removed ones
      for (var menuSize in oldSizeSet.difference(newSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.delete(ref);
      }

      // Update existing ones
      for (var menuSize in newSizeSet.intersection(oldSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.update(ref, menuSize.toJson());
      }

      // 3. The Atomic Commit
      // Even if the phone dies RIGHT NOW, Firestore has this saved in its local cache.
      await batch.commit();
    } else {
      _menuItemRepository.update(newMenuItem);
    }
  }

  void deleteMenuItem(MenuItem menuItem) {
    _menuItemRepository.delete(menuItem.id);
  }

  void addMenuCategory(MenuItemCategory newCategory) {
    newCategory.restaurantId = _restId;
    _menuCategoryRepository.create(newCategory);
  }

  void updateMenuCategory(MenuItemCategory newCategory) {
    newCategory.restaurantId = _restId;
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
    newAddOn.restaurantId = _restId;
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
  List<MenuItem> get menuItems => _menuItems;
  Map<String, MenuItem> _menuItemsMap = {};
  Map<String, MenuItem> get menuItemsMap {
    return _menuItemsMap;
  }

  List<SizeOption> _sizeOptions = [];
  List<SizeOption> get sizeOPtions => _sizeOptions;

  List<MenuItemCategory> _menuCategories = [];
  List<MenuItemCategory> get menuItemCategories => _menuCategories;
}
