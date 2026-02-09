import 'package:flutter/material.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

class CartProvider extends ChangeNotifier {
  final Order currentOrder; 

  CartProvider({required this.currentOrder});

  List<OrderItem> get items => List.unmodifiable(currentOrder.inCart);

  //add new item to cart or update its quantity if already exist.
  void addToCart(OrderItem newItem) {
    try {
      final index = currentOrder.inCart.indexWhere(
        (item) =>
            item.menuItemId == newItem.menuItemId &&
            item.size.name == newItem.size.name &&
            _mapEquals(item.addOns, newItem.addOns),
      );

      if (index != -1) {
        final existing = currentOrder.inCart[index];
        currentOrder.inCart[index] = OrderItem(
          menuItemId: existing.menuItemId,
          item: existing.item,
          addOns: existing.addOns,
          menuItemPrice: existing.menuItemPrice,
          size: existing.size,
          note: existing.note,
          quantity: existing.quantity + newItem.quantity,
        );
      } else {
        currentOrder.inCart.add(newItem);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }

  //order items can have same menu item but different size or add ons
  void removeItem(OrderItem target) {
    currentOrder.inCart.removeWhere(
      (item) =>
          item.menuItemId == target.menuItemId &&
          item.size.name == target.size.name &&
          _mapEquals(item.addOns, target.addOns),
    );
    notifyListeners();
  }

  void updateCartItem(OrderItem updatedItem) {
    final index = currentOrder.inCart.indexWhere(
      (item) =>
          item.menuItemId == updatedItem.menuItemId &&
          item.size.name == updatedItem.size.name &&
          _mapEquals(item.addOns, updatedItem.addOns),
    );

    if (index != -1) {
      currentOrder.inCart[index] = updatedItem;
      notifyListeners();
    }
  }

  double get totalAmount {
    return currentOrder.inCart.fold(0.0, (sum, item) {
      final addOnsTotal = item.addOns.values.fold(0.0, (a, b) => a + b);
      return sum + (item.menuItemPrice + addOnsTotal) * item.quantity;
    });
  }

  int get totalItemsCount {
    return currentOrder.inCart.fold(0, (sum, item) => sum + item.quantity);
  }

  bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}
