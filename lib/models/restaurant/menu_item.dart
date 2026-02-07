import 'package:queue_station_app/models/restaurant/size.dart';

import 'add_on.dart';
import 'menu_item_category.dart';

class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? prepTimeMinutes;
  final MenuItemCategory category;
  final List<Size> sizes = []; // Sizes handles the pricing
  final List<AddOn> addOns = [];

  MenuItem({
    required this.id,
    this.image,
    required this.name,
    required this.description,
    this.prepTimeMinutes,
    required this.category,
  });
}
