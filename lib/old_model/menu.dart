import 'dart:typed_data';

import 'package:queue_station_app/old_model/menu_size.dart';

class Menu {
  final int? menuId;
  final String name;
  final String description;
  final double price;
  final int minPreparationTime;
  final int maxPreparationTime;
  final Uint8List? menuImage;
  final bool isAvailable;
  final int categoryId;
  final List<MenuSize> sizes;
  final List<int> addOnIds;

  Menu({
    this.menuId,
    required this.name,
    required this.description,
    required this.price,
    this.menuImage,
    required this.isAvailable,
    required this.categoryId,
    required this.minPreparationTime,
    required this.maxPreparationTime,
    List<MenuSize>? sizes,
    List<int>? addOnIds,
  }) : sizes = sizes ?? [],
       addOnIds = addOnIds ?? [];

  void addSize(MenuSize size) {
    sizes.add(size);
  }

  void addOn(int addOnId) {
    addOnIds.add(addOnId);
  }
}
