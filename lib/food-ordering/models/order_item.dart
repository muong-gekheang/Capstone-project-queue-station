class OrderItem {
  final String productName;
  final String? image;
  final String? sizeLabel;
  final List<String> addonNames;
  final double priceAtOrder;
  final int quantity;
  final String? note;

  OrderItem({
    required this.productName,
    this.image,
    this.sizeLabel,
    required this.addonNames,
    required this.priceAtOrder,
    required this.quantity,
    this.note
  });
}