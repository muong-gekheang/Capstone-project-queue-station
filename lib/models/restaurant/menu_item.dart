import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:uuid/uuid.dart';
import 'add_on.dart';
import 'menu_size.dart';

part 'menu_item.g.dart';

final uuid = Uuid();

@JsonSerializable(explicitToJson: true)
class MenuItem {
  final String id;
  final String? image;
  final String name;
  final double minPrice;
  final String description;
  final int? minPrepTimeMinutes;
  final int? maxPrepTimeMinutes;

  @JsonKey(name: 'categoryId')
  final String categoryId;
  final String restaurantId;

  @JsonKey(defaultValue: <String>[])
  final List<String> menuSizeOptionIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> addOnIds;

  bool isAvailable;

  // Transient fields (mutable)
  @JsonKey(includeFromJson: false, includeToJson: false)
  MenuItemCategory? category;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MenuSize> sizes = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<AddOn> addOns = [];

  MenuItem({
    String? id,
    this.image,
    required this.name,
    required this.description,
    this.minPrepTimeMinutes,
    this.maxPrepTimeMinutes,
    required this.minPrice,
    required this.categoryId,
    required this.restaurantId,
    List<String>? menuSizeOptionIds,
    List<String>? addOnIds,
    this.isAvailable = true,
    this.category,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
  })  : id = id ?? uuid.v4(),
        menuSizeOptionIds = menuSizeOptionIds ?? [],
        addOnIds = addOnIds ?? [],
        sizes = sizes ?? [],
        addOns = addOns ?? [];

  MenuItem copyWith({
    String? image,
    String? name,
    int? minPrepTimeMinutes,
    int? maxPrepTimeMinutes,
    double? minPrice,
    String? categoryId,
    MenuItemCategory? category,
    List<String>? menuSizeOptionIds,
    List<String>? addOnIds,
    bool? isAvailable,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    String? restaurantId,
  }) {
    return MenuItem(
      id: id,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description,
      minPrepTimeMinutes: minPrepTimeMinutes ?? this.minPrepTimeMinutes,
      maxPrepTimeMinutes: maxPrepTimeMinutes ?? this.maxPrepTimeMinutes,
      minPrice: minPrice ?? this.minPrice,
      categoryId: categoryId ?? this.categoryId,
      restaurantId: restaurantId ?? this.restaurantId,
      menuSizeOptionIds: menuSizeOptionIds ?? this.menuSizeOptionIds,
      addOnIds: addOnIds ?? this.addOnIds,
      isAvailable: isAvailable ?? this.isAvailable,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      addOns: addOns ?? this.addOns,
    );
  }

  double cheapestPrice(List<MenuSize> sizes) {
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
