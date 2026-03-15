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

  factory MenuItemCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuItemCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemCategoryToJson(this);
}
