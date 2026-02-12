import 'package:uuid/uuid.dart';

class AddOn {
  final String id;
  final String name;
  double price;
  final String? image;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
    this.image,
  });
}
