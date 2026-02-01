import 'package:flutter/material.dart';
import 'package:queue_station_app/model/entities/cart_item.dart';
import 'package:queue_station_app/model/entities/order.dart';
import 'package:queue_station_app/model/entities/order_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> cartItems, double total) {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      totalAmount: total,
      items: cartItems
          .map(
            (cartItem) => OrderItem(
              productName: cartItem.menuItem.name,
              image: cartItem.menuItem.image,
              sizeLabel: cartItem.selectedSize?.name,
              addons: {
                for (final addon in cartItem.selectedAddOns)
                  addon.name: addon.price,
              },
              priceAtOrder: cartItem.totalItemPrice / cartItem.quantity,
              quantity: cartItem.quantity,
              note: cartItem.note,
            ),
          )
          .toList(),
    );

    _orders.insert(0, newOrder); // Newest order at the top
    notifyListeners();
  }
}
