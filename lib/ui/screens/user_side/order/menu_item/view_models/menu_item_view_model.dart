import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/services/order_provider.dart';
import '../../../../../../data/repositories/queue_entry/queue_entry_repository.dart';

class MenuItemViewModel extends ChangeNotifier {
  final MenuItem menuItem;
  final OrderItem? cartItem;
  final OrderProvider orderProvider;
  final QueueEntryRepository queueEntryRepository;

  MenuItemViewModel({
    required this.menuItem,
    required this.orderProvider,
    this.cartItem,
    required this.queueEntryRepository
  }) {
    _initialize();
  }

  MenuSize? _selectedSize;
  MenuSize? get selectedSize => _selectedSize;

  final Map<String, bool> _selectedAddOns = {};
  Map<String, bool> get selectedAddOns => _selectedAddOns;

  int _quantity = 1;
  int get quantity => _quantity;

  final TextEditingController noteController = TextEditingController();

  void _initialize() {
    for (final addOn in menuItem.addOns) {
      _selectedAddOns[addOn.id] = false;
    }

    if (cartItem != null) {
      _loadFromCartItem(cartItem!);
    } else {
      _selectedSize = menuItem.sizes.isNotEmpty ? menuItem.sizes.first : null;
    }
  }

  void _loadFromCartItem(OrderItem item) {
    _quantity = item.quantity;
    noteController.text = item.note ?? "";

    _selectedSize = menuItem.sizes.firstWhere(
      (s) => s.sizeOption?.name == item.size.name,
      orElse: () => menuItem.sizes.first,
    );

    for (final entry in item.addOns.entries) {
      if (_selectedAddOns.containsKey(entry.key)) {
        _selectedAddOns[entry.key] = true;
      }
    }
  }

  void selectSize(MenuSize size) {
    _selectedSize = size;
    notifyListeners();
  }

  void toggleAddOn(String id, bool value) {
    _selectedAddOns[id] = value;
    notifyListeners();
  }

  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  double get totalPrice {
    final base = _selectedSize?.price ?? 0;

    final addOnPrice = menuItem.addOns
        .where((a) => _selectedAddOns[a.id] == true)
        .fold(0.0, (sum, a) => sum + a.price);

    return (base + addOnPrice) * _quantity;
  }

  double get startingPrice {
    if (menuItem.sizes.isEmpty) return 0;
    return menuItem.sizes.map((s) => s.price).reduce((a, b) => a < b ? a : b);
  }

  void saveItem() {
    if (_selectedSize == null) {
      throw Exception("Size must be selected");
    }

    final selectedAddOns = menuItem.addOns
        .where((a) => _selectedAddOns[a.id] == true)
        .toList();

    final addOnsMap = {for (final a in selectedAddOns) a.id: a.price};

    final orderItem = OrderItem(
      id: Uuid().v4(),
      orderId: orderProvider.currentOrder.id,
      menuItemId: menuItem.id,
      item: menuItem,
      size: _selectedSize!.sizeOption,
      menuItemPrice: _selectedSize!.price,
      addOns: addOnsMap,
      quantity: _quantity,
      note: noteController.text.isNotEmpty ? noteController.text : null,
      orderItemStatus: OrderItemStatus.pending,
    );

    if (cartItem == null) {
      orderProvider.addToCart(orderItem);
    } else {
      orderProvider.updateCartItem(cartItem!, orderItem);
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
