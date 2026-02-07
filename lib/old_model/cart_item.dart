import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/add_on.dart';
import 'package:queue_station_app/old_model/menu_item.dart';
import 'package:queue_station_app/old_model/size_option.dart';

class CartItem {
  final String id;
  final MenuItem menuItem;
  final SizeOption? selectedSize;
  final List<AddOn> selectedAddOns;
  int quantity;
  final String note;

  CartItem({
    String? id,
    required this.menuItem,
    this.selectedSize,
    this.selectedAddOns = const [],
    this.quantity = 1,
    this.note = '',
  }) : id = id ?? UniqueKey().toString();

  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    SizeOption? selectedSize,
    List<AddOn>? selectedAddOns,
    String? note,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedAddOns: selectedAddOns ?? List.from(this.selectedAddOns),
      note: note ?? this.note,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalItemPrice {
    double base = menuItem.basePrice;

    if (selectedSize != null) {
      base += selectedSize!.price;
    }

    // Add all addon prices
    double addonsTotal = selectedAddOns.fold(
      0,
      (sum, addon) => sum + addon.price,
    );

    return (base + addonsTotal) * quantity;
  }

  bool isSameConfig(CartItem other) {
    return menuItem.id == other.menuItem.id &&
        selectedSize?.id == other.selectedSize?.id &&
        selectedAddOns.length == other.selectedAddOns.length &&
        selectedAddOns.every(
          (addon) => other.selectedAddOns.any((o) => o.id == addon.id),
        );
  }
}
