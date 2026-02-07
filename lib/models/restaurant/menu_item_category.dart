class MenuItemCategory {
  final String id;
  final String name;

  MenuItemCategory({required this.id, required this.name});
}

final categories = [
  MenuItemCategory(id: 'c1', name: 'Burgers'),
  MenuItemCategory(id: 'c2', name: 'Pizza'),
  MenuItemCategory(id: 'c3', name: 'Drinks'),
  MenuItemCategory(id: 'c4', name: 'Desserts'),
];
