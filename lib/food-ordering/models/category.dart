class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}

final categories = [
  Category(id: 'c1', name: 'Burgers'),
  Category(id: 'c2', name: 'Pizza'),
  Category(id: 'c3', name: 'Drinks'),
  Category(id: 'c4', name: 'Desserts'),
];
