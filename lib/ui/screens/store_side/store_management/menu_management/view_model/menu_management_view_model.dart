import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/services/store/menu_service.dart';

class MenuManagementViewModel extends ChangeNotifier {
  final MenuService _menuService;

  StreamSubscription<List<MenuItem>>? _menuSubscription;
  StreamSubscription<List<MenuItemCategory>>? _menuCategorySubscription;
  StreamSubscription<List<AddOn>>? _addOnSubscription;
  StreamSubscription<List<SizeOption>>? _sizeOptionSubscription;

  bool _isLoading = true;
  bool _isDisposed = false;

  // --- State Variables ---
  List<MenuItem> _allMenuItems = [];
  List<MenuItemCategory> _allCategories = [];
  List<AddOn> _allAddOns = [];
  List<SizeOption> _sizingOptions = [];
  int _selectedIndex = -1;
  String _selectedCategoryId = '';
  String _searchQuery = '';

  // --- Getters ---
  List<MenuItem> get allMenuItems => _allMenuItems;
  List<MenuItemCategory> get allCategories => _allCategories;
  List<AddOn> get allAddOns => _allAddOns;
  List<SizeOption> get sizeOptions => _sizingOptions;
  int get selectedIndex => _selectedIndex;
  String get selectedCategoryId => _selectedCategoryId;
  MenuItemCategory? get selectedCategory {
    for (var cat in _allCategories) {
      if (cat.id == _selectedCategoryId) return cat;
    }
    return null;
  }

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  MenuManagementViewModel({required MenuService menuService})
    : _menuService = menuService {
    _subscribe();
    initialize();
  }

  // --- Stream Management ---
  void _subscribe() {
    _menuSubscription = _menuService.streamMenuItems.listen(
      (items) {
        if (_isDisposed) return;
        _allMenuItems = items;
        debugPrint("MenuItems: ${items.length}");
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );

    _menuCategorySubscription = _menuService.streamMenuCategories.listen(
      (categories) {
        if (_isDisposed) return;
        _allCategories = categories;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );

    _addOnSubscription = _menuService.streamAddOns.listen(
      (addOns) {
        if (_isDisposed) return;
        _allAddOns = addOns;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );

    _sizeOptionSubscription = _menuService.streamSizeOptions.listen(
      (data) {
        if (_isDisposed) return;
        _sizingOptions = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _menuSubscription?.cancel();
    _menuCategorySubscription?.cancel();
    _addOnSubscription?.cancel();
    _sizeOptionSubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  // --- Initializer ---
  void initialize() {
    if (_allCategories.isNotEmpty) {
      _selectedCategoryId = _allCategories[selectedIndex].id;
    }
  }

  // --- Data Piping (State Setters) ---
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    if (index != -1) {
      _selectedCategoryId = _allCategories[index].id;
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // --- Logic Signatures (Piping to Service) ---

  List<MenuItem> getFilteredMenuList() {
    final bool isAllSelected = _selectedIndex == -1;
    final bool isSearching = _searchQuery.isNotEmpty;

    return _allMenuItems.where((e) {
      final matchesSearch = e.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory = e.categoryId == _selectedCategoryId;

      if (isSearching) {
        return matchesSearch;
      } else if (isAllSelected) {
        return true;
      } else {
        return matchesCategory;
      }
    }).toList();
  }

  void updateMenuItem(
    MenuItem newMenuItem,
    MenuItem oldMenuItem,
    Uint8List? pickedLogoBytes,
  ) {
    _menuService.updateMenuItem(newMenuItem, oldMenuItem, pickedLogoBytes);
  }

  void toggleMenuAvailability(MenuItem menu, bool isAvailable) {
    menu.isAvailable = isAvailable;
    _menuService.updateMenuItem(menu, null, null);
  }

  void removeMenuItem(MenuItem item) {
    _menuService.deleteMenuItem(item);
  }

  void addMenuItem(MenuItem newItem, Uint8List? selectedImageBytes) {
    _menuService.addMenuItem(newItem, selectedImageBytes);
  }

  void addNewCategory(
    MenuItemCategory newCategory,
    Uint8List? selectedImageBytes,
  ) {
    _menuService.addMenuCategory(newCategory, selectedImageBytes);
    _selectedCategoryId = newCategory.id;
    notifyListeners();
  }

  void addNewAddOn(AddOn newAddon, Uint8List? selectedImageBytes) {
    _menuService.addAddOn(newAddon, selectedImageBytes);
  }

  void addNewSizeOption(SizeOption newSizeOption) {
    _menuService.addSizeOption(newSizeOption);
  }

  Future<MenuItem> getMenuitemDetails(MenuItem menuItem) {
    final category = _allCategories.firstWhere(
      (e) => e.id == menuItem.categoryId,
    );
    return _menuService.getMenuItemDetails(
      menuItem.copyWith(category: category),
    );
  }
}
