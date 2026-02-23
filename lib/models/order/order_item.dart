import '../restaurant/menu_item.dart';
import '../restaurant/size_option.dart';

enum OrderItemStatus { pending, accepted, rejected, cancelled }

class OrderItem {
  final String menuItemId; // For Storing in the DB
  final MenuItem item; // For using direct in memory
  final Map<String, double> addOns; // AddOn ID and current price snapshot
  final double menuItemPrice; // Menu Item price current snapshot
  final SizeOption size; // We will use only the name
  final int quantity;
  final String? note;
  final OrderItemStatus orderItemStatus;

  OrderItem({
    required this.quantity,
    this.note,
    required this.item,
    required this.addOns,
    required this.menuItemId,
    required this.menuItemPrice,
    required this.size,
    required this.orderItemStatus,
  });

  OrderItem copyWith({
    String? menuItemId,
    MenuItem? item,
    Map<String, double>? addOns,
    double? menuItemPrice,
    SizeOption? size,
    int? quantity,
    String? note,
    OrderItemStatus? orderItemStatus,
  }) {
    return OrderItem(
      quantity: quantity ?? this.quantity,
      item: item ?? this.item,
      addOns: addOns != null ? Map.from(addOns) : Map.from(this.addOns),
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemPrice: menuItemPrice ?? this.menuItemPrice,
      size: size ?? this.size,
      note: note ?? this.note,
      orderItemStatus: orderItemStatus ?? this.orderItemStatus,
    );
  }

  double calculateTotalPrice() {
    double totalPrice = menuItemPrice; // base price
    totalPrice += addOns.values.fold(
      0.0,
      (sum, price) => sum + price,
    ); // add-ons
    totalPrice *= quantity; // quantity
    return totalPrice;
  }
}
