import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:uuid/uuid.dart';
import 'add_on.dart';
import 'menu_item_category.dart';

class MenuItem {
  final String id = Uuid().v4();
  final String? image;
  final String name;
  final String description;
  final int? minPrepTimeMinutes;
  final int? maxPrepTimeMinutes;
  final MenuItemCategory category;
  final List<MenuSize> sizes = []; // Sizes handles the pricing
  final List<AddOn> addOns = [];
  bool isAvailable;

  MenuItem({
    this.image,
    required this.name,
    required this.description,
    this.minPrepTimeMinutes,
    this.maxPrepTimeMinutes,
    required this.category,
    required this.isAvailable,
  });
}
