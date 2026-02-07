import 'add_on.dart';
import 'category.dart';
import 'size_option.dart';

class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? prepTimeMinutes;
  final MenuItemCategory category;
  final List<SizeOption> sizes = []; // SizeOption handles the pricing
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
