import 'dart:typed_data';

class Menu {
  final int? menuId;
  final String name;
  final String description;
  final double price;
  final int preparationTime;
  final Uint8List? menuImage;
  final bool isAvailable;
  final int categoryId;

  Menu({this.menuId, required this.name, required this.description, required this.price, required this.preparationTime, this.menuImage, required this.isAvailable, required this.categoryId});

}
