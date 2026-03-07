import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart' as order_model;
import 'package:queue_station_app/data/repositories/restaurants/menu_item_repository.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuItemRepository menuItemRepository;
  final OrderRepository orderRepository;

  MenuViewModel({
    required this.menuItemRepository,
    required this.orderRepository
  });

  List<MenuItem> _menuItems = [];
  List<MenuItem> get menuItems => _menuItems;

  order_model.Order get currentOrder => orderRepository.currentOrder;

  List<OrderItem> get cartItems => currentOrder.inCart;
  List<OrderItem> get orderedItems => currentOrder.ordered;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Load all menu items
  Future<void> loadMenuItems() async {
    _isLoading = true;
    notifyListeners();

    final (data, _) = await menuItemRepository.getAll(20, null);
    _menuItems = data;

    _isLoading = false;
    notifyListeners();
  }

  // Search & filter by category
  Future<void> searchMenuItems({String query = '', String? category}) async {
    final (data, _) = await menuItemRepository.getSearchMenuItems(
      query,
      category,
      20,
      null,
    );
    _menuItems = data;
    notifyListeners();
  }

  // Provide filtered items for UI
  List<MenuItem> filteredMenuItems({String query = '', String? category}) {
    return _menuItems.where((item) {
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          category == null || category.isEmpty || item.category.id == category;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  int get totalCartItemsCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalCartAmount => cartItems.fold(0.0, (sum, item) {
    final addOnsTotal = item.addOns.values.fold(0.0, (a, b) => a + b);
    return sum + (item.menuItemPrice + addOnsTotal) * item.quantity;
  });
}


