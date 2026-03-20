import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'menu_item_category.g.dart';

@JsonSerializable()
class MenuItemCategory {
  final String id;
  final String name;
  String? restaurantId;
  String? imageLink;

  MenuItemCategory({required this.id, required this.name, this.imageLink});

  MenuItemCategory copyWith({
    String? id,
    String? name,
    String? restaurantId,
    String? imageLink,
  }) {
    return MenuItemCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageLink: imageLink ?? this.imageLink,
    )..restaurantId = restaurantId ?? this.restaurantId;
  }

  factory MenuItemCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuItemCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemCategoryToJson(this);
}
