class AddOn {
  final String id; 
  final String name;
  final String? description;
  final double price;
  final String? image;

  AddOn({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image
  });
}

