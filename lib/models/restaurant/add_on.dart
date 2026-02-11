import 'package:uuid/uuid.dart';

class AddOn {
  final String id = Uuid().v4();
  final String name;
  double price;
  final String? image;

  AddOn({
    required this.name,
    required this.price,
    this.image,
  });
}
