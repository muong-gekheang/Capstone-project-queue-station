import 'package:json_annotation/json_annotation.dart';

part 'add_on.g.dart';

@JsonSerializable()
class AddOn {
  final String id;
  final String name;
  double price;
  final String? image;
  String restaurantId;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
    required this.restaurantId,
    this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddOn &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          image == other.image;

  @override
  int get hashCode => Object.hash(id, name, price, image);

  factory AddOn.fromJson(Map<String, dynamic> json) => _$AddOnFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnToJson(this);
}
