import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';

import 'add_on.dart';
import 'menu_item_category.dart';

part 'menu_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? minPrepTimeMinutes;
  final int? maxPrepTimeMinutes;
  final String categoryId;

  @JsonKey(defaultValue: <String>[])
  final List<String> sizeOptionIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> addOnIds;

  bool isAvailable;

  MenuItem({
    required this.id,
    this.image,
    required this.name,
    required this.description,
    this.minPrepTimeMinutes,
    this.maxPrepTimeMinutes,
    required this.categoryId,
    MenuItemCategory? category,
    List<String>? sizeOptionIds,
    List<String>? addOnIds,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    this.isAvailable = true,
  }) : sizeOptionIds =
           sizeOptionIds ??
           (sizes ?? []).map((s) => s.sizeOption.name).toList(),
       addOnIds = addOnIds ?? (addOns ?? []).map((a) => a.id).toList();

  MenuItem copyWith({
    String? id,
    String? image,
    String? name,
    String? description,
    int? minPrepTimeMinutes,
    int? maxPrepTimeMinutes,
    String? categoryId,
    MenuItemCategory? category,
    List<String>? sizeOptionIds,
    List<String>? addOnIds,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      minPrepTimeMinutes: minPrepTimeMinutes ?? this.minPrepTimeMinutes,
      maxPrepTimeMinutes: maxPrepTimeMinutes ?? this.maxPrepTimeMinutes,
      categoryId: categoryId ?? this.categoryId,
      sizeOptionIds: sizeOptionIds ?? List<String>.from(this.sizeOptionIds),
      addOnIds: addOnIds ?? List<String>.from(this.addOnIds),
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  double cheapestPrice(List<MenuSize> sizes) {
    if (sizes.isEmpty) return 0.0;
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Null get sizes => null;

  Null get addOns => null;

  set category(MenuItemCategory? category) {}

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
