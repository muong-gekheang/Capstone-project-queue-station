import 'package:uuid/uuid.dart';

class MenuItemCategory {
  final String id = Uuid().v4();
  final String name;
  String? imageLink;

  MenuItemCategory({ required this.name, this.imageLink});
}

final categories = [
  MenuItemCategory(name: 'Burgers'),
  MenuItemCategory(name: 'Pizza'),
  MenuItemCategory(name: 'Drinks'),
  MenuItemCategory(name: 'Desserts'),
];
