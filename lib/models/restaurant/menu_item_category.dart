import 'package:uuid/uuid.dart';

class MenuItemCategory {
  final String id;
  final String name;
  String? imageLink;

  MenuItemCategory({ required this.id, required this.name, this.imageLink});
}

final categories = [
  MenuItemCategory(name: 'Burgers', id: Uuid().v4(), ),
  MenuItemCategory(name: 'Pizza', id: Uuid().v4()),
  MenuItemCategory(name: 'Drinks', id: Uuid().v4()),
  MenuItemCategory(name: 'Desserts', id: Uuid().v4()),
];
