import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:uuid/uuid.dart';
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

  double cheapestPrice() {
    if (sizes.isEmpty) return 0.0;
    return sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }
}
