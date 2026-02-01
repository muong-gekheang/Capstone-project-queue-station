import 'package:flutter/material.dart';
import 'package:queue_station_app/model/entities/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem newItem) {
    try {
      final existingItemIndex = _items.indexWhere(
        (item) => item.isSameConfig(newItem),
      );

      if (existingItemIndex != -1) {
        _items[existingItemIndex].quantity += newItem.quantity;
      } else {
        _items.add(newItem);
      }

      notifyListeners(); //used for rebuilding any widgets that use the provider
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void updateCartItem(CartItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  // Clear Cart (Done after Order is confirmed)
  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalItemsCount {
    int count = 0;
    for (final item in _items) {
      count += item.quantity;
    }
    return count;
  }
}
