import 'package:json_annotation/json_annotation.dart';

part 'add_on.g.dart';

@JsonSerializable()
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

  factory AddOn.fromJson(Map<String, dynamic> json) => _$AddOnFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnToJson(this);
}
