import '../restaurant/menu_item.dart';
import '../restaurant/size_option.dart';

class OrderItem {
  final String menuItemId; // For Storing in the DB
  final MenuItem item; // For using direct in memory
  final Map<String, double> addOns; // AddOn ID and current price snapshot
  final double menuItemPrice; // Menu Item price current snapshot
  final SizeOption size; // We will use only the name
  final int quantity;
  final String? note;

  OrderItem({
    required this.quantity,
    this.note,
    required this.item,
    required this.addOns,
    required this.menuItemId,
    required this.menuItemPrice,
    required this.size,
  });
}
