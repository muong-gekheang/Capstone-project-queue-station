import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/image/image_repository.dart';
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
  final ImageRepository _imageRepository;
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
    required ImageRepository imageRepository,
  }) : _userProvider = userProvider,
       _menuItemRepository = menuItemRepository,
       _menuCategoryRepository = menuCategoryRepository,
       _addOnRepository = addOnRepository,
       _sizingOptionRepository = sizingOptionRepository,
       _imageRepository = imageRepository,
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
    try {
      return await _menuItemRepository.getMenuItemById(menuItemId);
    } catch (err) {
      debugPrint("Menu: Err $err");
      rethrow;
    }
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

  void addMenuItem(MenuItem newMenu, Uint8List? pickedLogoBytes) {
    if (pickedLogoBytes != null && pickedLogoBytes.isNotEmpty) {
      _imageRepository
          .uploadLogo(pickedLogoBytes, 'menu_item_${newMenu.id}')
          .then((imageUrl) {
            final menuWithLogo = newMenu.copyWith(
              image: imageUrl,
              restaurantId: _restId,
            );
            _menuItemRepository.create(menuWithLogo);
            for (var menuSize in newMenu.sizes) {
              _menuSizeRepository.create(menuSize);
            }
          });
      return;
    }
    MenuItem menuToAdd = newMenu.copyWith(restaurantId: _restId);
    _menuItemRepository.create(menuToAdd);
    for (var menuSize in newMenu.sizes) {
      _menuSizeRepository.create(menuSize);
    }
  }

  Future<void> updateMenuItem(
    MenuItem newMenuItem,
    MenuItem? oldMenuItem,
    Uint8List? pickedLogoBytes,
  ) async {
    newMenuItem = newMenuItem.copyWith(restaurantId: _restId);
    oldMenuItem = oldMenuItem?.copyWith(restaurantId: _restId);

    Future<MenuItem> resolveImage() async {
      if (pickedLogoBytes != null) {
        if (oldMenuItem?.image != null) {
          final uri = Uri.parse(oldMenuItem!.image!);
          final fileName = uri.pathSegments.last.split('%2F').last;
          await _imageRepository.deleteLogo(fileName);
        }
        final url = await _imageRepository.uploadLogo(
          pickedLogoBytes,
          'menu_item_${newMenuItem.id}',
        );
        return newMenuItem.copyWith(image: url);
      }
      return newMenuItem;
    }

    final resolvedMenuItem = await resolveImage();

    if (oldMenuItem != null) {
      final batch = FirebaseFirestore.instance.batch();

      final itemRef = FirebaseFirestore.instance
          .collection('menu_items')
          .doc(resolvedMenuItem.id);
      batch.set(itemRef, resolvedMenuItem.toJson(), SetOptions(merge: true));

      final newSizeSet = resolvedMenuItem.sizes.toSet();
      final oldSizeSet = oldMenuItem.sizes.toSet();

      for (var menuSize in newSizeSet.difference(oldSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.set(ref, menuSize.toJson());
      }

      for (var menuSize in oldSizeSet.difference(newSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.delete(ref);
      }

      for (var menuSize in newSizeSet.intersection(oldSizeSet)) {
        final ref = FirebaseFirestore.instance
            .collection('sizes')
            .doc(menuSize.id);
        batch.update(ref, menuSize.toJson());
      }

      await batch.commit();
    } else {
      await _menuItemRepository.update(resolvedMenuItem);
    }
  }

  void deleteMenuItem(MenuItem menuItem) async {
    try {
      if (menuItem.image != null) {
        print("Deleting image: ${menuItem.image}");
        await _imageRepository.deleteLogo(menuItem.image!);
        print("image in storage is deleted");
      }
    } catch (e) {
      print("Image delete failed: $e");
    }
    await _menuItemRepository.delete(menuItem.id);
  }

  void addMenuCategory(
    MenuItemCategory newCategory,
    Uint8List? selectedImageBytes,
  ) {
    newCategory.restaurantId = _restId;

    print('=== addMenuCategory called ===');
    print('selectedImageBytes: $selectedImageBytes');
    print('selectedImageBytes isNull: ${selectedImageBytes == null}');
    print('selectedImageBytes isEmpty: ${selectedImageBytes?.isEmpty}');

    if (selectedImageBytes != null && selectedImageBytes.isNotEmpty) {
      _imageRepository
          .uploadLogo(selectedImageBytes, 'menu_category_${newCategory.id}')
          .then((imageUrl) {
            final categoryWithLogo = newCategory.copyWith(imageLink: imageUrl);
            _menuCategoryRepository.create(categoryWithLogo);
          });
      return;
    }
    _menuCategoryRepository.create(newCategory);
  }

  void updateMenuCategory(MenuItemCategory newCategory) {
    newCategory.restaurantId = _restId;
    _menuCategoryRepository.update(newCategory);
  }

  void deleteMenuCategory(MenuItemCategory menuCategory) {
    _menuCategoryRepository.delete(menuCategory.id);
  }

  void addAddOn(AddOn newAddOn, Uint8List? selectedImageBytes) {
    newAddOn.restaurantId = _restId;

    if (selectedImageBytes != null && selectedImageBytes.isNotEmpty) {
      _imageRepository
          .uploadLogo(selectedImageBytes, 'add_on_${newAddOn.id}')
          .then((imageUrl) {
            AddOn newAddOnWithLogo = newAddOn.copyWith(image: imageUrl);
            _addOnRepository.create(newAddOnWithLogo);
          });
    } else {
      _addOnRepository.create(newAddOn);
    }
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
