class SizeOption {
  final String id; 
  final String name; 
  final double price;
  final String? description;
  final bool isDefault;

  SizeOption({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.isDefault = false,
  });
}

