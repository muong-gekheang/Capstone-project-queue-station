import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'menu_item_category.dart';
import 'add_on.dart';
import 'menu_size.dart';

part 'menu_item.g.dart';

final uuid = Uuid();

@JsonSerializable(explicitToJson: true)
class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? minPrepTimeMinutes;
  final int? maxPrepTimeMinutes;

  @JsonKey(name: 'categoryId')
  final String categoryId;

  @JsonKey(name: 'sizeOptionIds', defaultValue: [])
  final List<String> sizeOptionIds;

  @JsonKey(name: 'addOnIds', defaultValue: [])
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
    required this.categoryId,
    List<String>? sizeOptionIds,
    List<String>? addOnIds,
    this.isAvailable = true,
  }) : id = id ?? uuid.v4(),
       sizeOptionIds = sizeOptionIds ?? [],
       addOnIds = addOnIds ?? [];

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  MenuItem copyWith({
    String? image,
    String? name,
    String? description,
    int? minPrepTimeMinutes,
    int? maxPrepTimeMinutes,
    String? categoryId,
    List<String>? sizeOptionIds,
    List<String>? addOnIds,
    bool? isAvailable,
    MenuItemCategory? category,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
  }) {
    return MenuItem(
        id: id,
        image: image ?? this.image,
        name: name ?? this.name,
        description: description ?? this.description,
        minPrepTimeMinutes: minPrepTimeMinutes ?? this.minPrepTimeMinutes,
        maxPrepTimeMinutes: maxPrepTimeMinutes ?? this.maxPrepTimeMinutes,
        categoryId: categoryId ?? this.categoryId,
        sizeOptionIds: sizeOptionIds ?? this.sizeOptionIds,
        addOnIds: addOnIds ?? this.addOnIds,
        isAvailable: isAvailable ?? this.isAvailable,
      )
      ..category = category ?? this.category
      ..sizes = sizes ?? this.sizes
      ..addOns = addOns ?? this.addOns;
  }

  double cheapestPrice(List<MenuSize> sizes) {
    if (sizes.isEmpty) return 0.0;
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }
}
