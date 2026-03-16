import 'package:json_annotation/json_annotation.dart';

part 'size_option.g.dart';

@JsonSerializable()
class SizeOption {
  final String id;
  final String name;
  String restaurantId;
  SizeOption({
    required this.name,
    required this.id,
    required this.restaurantId,
  });

  factory SizeOption.fromJson(Map<String, dynamic> json) =>
      _$SizeOptionFromJson(json);

  Map<String, dynamic> toJson() => _$SizeOptionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, restaurantId);
}
