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
  final String restaurantId;

  @JsonKey(defaultValue: <String>[])
  final List<String> menuSizeOptionIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> addOnIds;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final MenuItemCategory category;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<MenuSize> sizes;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<AddOn> addOns;

  bool isAvailable;

  MenuItem({
    required this.id,
    this.image,
    required this.name,
    required this.description,
    this.minPrepTimeMinutes,
    this.maxPrepTimeMinutes,
    String? categoryId,
    MenuItemCategory? category,
    List<String>? menuSizeOptionIds,
    List<String>? addOnIds,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    this.isAvailable = true,
    required this.restaurantId,
  }) : categoryId = categoryId ?? category?.id ?? 'unknown_category',
       category =
           category ??
           MenuItemCategory(
             id: categoryId ?? 'unknown_category',
             name: 'Unknown',
           ),
       sizes = sizes ?? [],
       addOns = addOns ?? [],
       menuSizeOptionIds =
           menuSizeOptionIds ??
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
    List<String>? menuSizeOptionIds,
    List<String>? addOnIds,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    bool? isAvailable,
    String? restaurantId,
  }) {
    return MenuItem(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      minPrepTimeMinutes: minPrepTimeMinutes ?? this.minPrepTimeMinutes,
      maxPrepTimeMinutes: maxPrepTimeMinutes ?? this.maxPrepTimeMinutes,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      menuSizeOptionIds:
          menuSizeOptionIds ?? List<String>.from(this.menuSizeOptionIds),
      addOnIds: addOnIds ?? List<String>.from(this.addOnIds),
      sizes: sizes ?? List<MenuSize>.from(this.sizes),
      addOns: addOns ?? List<AddOn>.from(this.addOns),
      isAvailable: isAvailable ?? this.isAvailable,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  double cheapestPrice() {
    if (sizes.isEmpty) return 0.0;
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
