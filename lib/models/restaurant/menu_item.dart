import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'add_on.dart';
import 'menu_item_category.dart';

class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? minPrepTimeMinutes;
  final int? maxPrepTimeMinutes;
  final MenuItemCategory category;
  final List<MenuSize> sizes; // Sizes handles the pricing
  final List<AddOn> addOns;
  bool isAvailable;

  MenuItem({
    required this.id,
    this.image,
    required this.name,
    required this.description,
    this.minPrepTimeMinutes,
    this.maxPrepTimeMinutes,
    required this.category,
    List<MenuSize>? sizes,
    List<AddOn>? addOns,
    this.isAvailable = true,
  }) : sizes = sizes ?? [],
       addOns = addOns ?? [];

  MenuItem copyWith({
    String? id,
    String? image,
    String? name,
    String? description,
    int? minPrepTimeMinutes,
    int? maxPrepTimeMinutes,
    MenuItemCategory? category,
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
      category: category ?? this.category,
      sizes: sizes ?? List<MenuSize>.from(this.sizes),
      addOns: addOns ?? List<AddOn>.from(this.addOns),
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  double cheapestPrice() {
    if (sizes.isEmpty) return 0.0;
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }
}
