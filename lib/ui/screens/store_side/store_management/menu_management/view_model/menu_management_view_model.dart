import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/services/store/menu_service.dart';

class MenuManagementViewModel extends ChangeNotifier {
  final MenuService _menuService;

  StreamSubscription<List<MenuItem>>? _menuSubscription;
  StreamSubscription<List<MenuItemCategory>>? _menuCategorySubscription;

  bool _isLoading = true;
  bool _isDisposed = false;

  // --- State Variables ---
  List<MenuItem> _allMenuItems = [];
  List<MenuItemCategory> _allCategories = [];
  int _selectedIndex = 0;
  String _selectedCategoryId = '';
  String _searchQuery = '';

  // --- Getters ---
  List<MenuItem> get allMenuItems => _allMenuItems;
  int get selectedIndex => _selectedIndex;
  String get selectedCategoryId => _selectedCategoryId;
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
  }

  @override
  void dispose() {
    _menuSubscription?.cancel();
    _menuCategorySubscription?.cancel();
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
    _selectedCategoryId = mockMenuCategories[index].id;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // --- Logic Signatures (Piping to Service) ---

  List<MenuItem> getFilteredMenuList() {
    return _allMenuItems
        .where(
          (e) =>
              (e.name.toLowerCase().startsWith(_searchQuery)) &&
              (e.categoryId == _selectedCategoryId),
        )
        .toList();
  }

  void toggleMenuAvailability(MenuItem menu, bool isAvailable) {
    // Logic Piping: We create a modified copy and send it to the service
    // menu.isAvailable = isAvailable; // If MenuItem is mutable
    _menuService.updateMenuItem(menu);
    // Note: notifyListeners() isn't needed here because the
    // stream listener above will catch the update and call it for us!
  }

  void deleteMenu(MenuItem menu) {
    _menuService.deleteMenuItem(menu);
  }

  void removeMenuItem(MenuItem item) {
    _menuService.deleteMenuItem(item);
  }

  void addMenuItem(MenuItem newItem) {
    _menuService.addMenuItem(newItem);
  }

  void AddNewCategory(MenuItemCategory newCategory) {
    _menuService.addMenuCategory(newCategory);
  }

  // --- Subscreen State Piping ---
  List<AddOn> _tempSelectedAddOns = [];
  final List<SizeOption> _tempSelectedSizes = [];

  List<AddOn> get tempSelectedAddOns => _tempSelectedAddOns;
  List<SizeOption> get tempSelectedSizes => _tempSelectedSizes;

  void setInitialAddOns(List<AddOn> initial) {
    _tempSelectedAddOns = List.from(initial);
    notifyListeners();
  }

  void toggleAddOn(AddOn addOn) {
    if (_tempSelectedAddOns.contains(addOn)) {
      _tempSelectedAddOns.remove(addOn);
    } else {
      _tempSelectedAddOns.add(addOn);
    }
    notifyListeners();
  }

  void saveAddOnsToMenu(MenuItem menu) {
    MenuItem newMenu = menu.copyWith(
      addOnIds: _tempSelectedAddOns.map((e) => e.id).toList(),
    );
    _tempSelectedAddOns.clear();

    _menuService.updateMenuItem(newMenu);
  }

  double getCheapestPrice(MenuItem menu) {
    if (menu.sizes.isEmpty) return 0.0;

    return menu.sizes.first.price;
  }
}
