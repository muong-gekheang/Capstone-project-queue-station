import 'dart:typed_data';

class MenuAddOn {
  final int? id;
  final String name;
  double price;
  final Uint8List? image;

  MenuAddOn({required this.id, required this.name, required this.price, this.image});
}