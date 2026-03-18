import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/services/cart_provider.dart';

class MenuItemScreen extends StatefulWidget {
  final MenuItem? item;
  final OrderItem? cartItem;

  const MenuItemScreen({super.key, this.item, this.cartItem});

  MenuItem get menuItem => item ?? cartItem!.item;

  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  MenuSize? _selectedSize;
  final Map<String, bool> _selectedAddOns = {};
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // init add-ons
    for (final addOn in widget.menuItem.addOns) {
      _selectedAddOns[addOn.id] = false;
    }

    if (widget.cartItem != null) {
      _loadFromOrderItem(widget.cartItem!);
    } else {
      _selectDefaultSize();
    }
  }

  void _selectDefaultSize() {
    if (widget.menuItem.sizes.isEmpty) return;
    _selectedSize = widget.menuItem.sizes.first;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadFromOrderItem(OrderItem orderItem) {
    _quantity = orderItem.quantity;
    _noteController.text = orderItem.note ?? "";

    _selectedSize = widget.menuItem.sizes.firstWhere(
      (s) => s.sizeOption?.name == orderItem.size.name,
      orElse: () => widget.menuItem.sizes.first,
    );

    for (final entry in orderItem.addOns.entries) {
      _selectedAddOns[entry.key] = true;
    }
  }

  double get _totalPrice {
    final basePrice = _selectedSize?.price ?? 0.0;

    final addOnsPrice = widget.menuItem.addOns
        .where((a) => _selectedAddOns[a.id] == true)
        .fold(0.0, (sum, a) => sum + a.price);

    return (basePrice + addOnsPrice) * _quantity;
  }

  double _getStartingPrice() {
    if (widget.menuItem.sizes.isEmpty) return 0.0;

    return widget.menuItem.sizes
        .map((s) => s.price)
        .reduce((a, b) => a < b ? a : b);
  }

  void _saveItem(BuildContext context) {
    final cart = context.read<CartProvider>();
    if (_selectedSize == null) return;

    final selectedAddOns = widget.menuItem.addOns
        .where((a) => _selectedAddOns[a.id] == true)
        .toList();

    final Map<String, double> addOnsMap = {
      for (final a in selectedAddOns) a.id: a.price,
    };

    final orderItem = OrderItem(
      menuItemId: widget.menuItem.id,
      item: widget.menuItem,
      size: _selectedSize!.sizeOption,
      menuItemPrice: _selectedSize!.price, // snapshot
      addOns: addOnsMap,
      quantity: _quantity,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      orderItemStatus: OrderItemStatus.pending,
      orderId: '',
      id: '',
    );

    if (widget.cartItem == null) {
      cart.addToCart(orderItem);
    } else {
      cart.updateCartItem(widget.cartItem!, orderItem);
    }

    Navigator.pop(context);
  }

  void _incrementQuantity() => setState(() => _quantity++);

  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.grey[200]),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: widget.menuItem.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.menuItem.image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Content section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.menuItem.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6835),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "From",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '\$${_getStartingPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Preparation time
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          if (widget.menuItem.maxPrepTimeMinutes != null)
                            Text(
                              'Maximum Prep Time: ${widget.menuItem.maxPrepTimeMinutes} minutes',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Description
                      Text(
                        widget.menuItem.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sizes section
                      if (widget.menuItem.sizes.isNotEmpty) ...[
                        Text(
                          'Sizes',
                          style: TextStyle(
                            color: const Color(0xFF0D47A1),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: widget.menuItem.sizes.map((size) {
                            return RadioListTile<MenuSize>(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      size.sizeOption!.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    '\$${size.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              value: size,
                              groupValue: _selectedSize,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSize = value;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: const Color(0xFFFF6835),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Add-ons section
                      if (widget.menuItem.addOns.isNotEmpty) ...[
                        Text(
                          'Add-ons',
                          style: TextStyle(
                            color: const Color(0xFF0D47A1),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: widget.menuItem.addOns
                              .map(
                                (addOn) => Column(
                                  children: [
                                    CheckboxListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              addOn.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '+\$${addOn.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: _selectedAddOns[addOn.id] ?? false,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedAddOns[addOn.id] =
                                              value ?? false;
                                        });
                                      },
                                      activeColor: const Color(0xFFFF6835),
                                      checkboxShape: const CircleBorder(),
                                      secondary:
                                          addOn.image != null &&
                                              addOn.image!.isNotEmpty
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              backgroundImage: AssetImage(
                                                addOn.image!,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.add_circle_outline,
                                              size: 28,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Note section
                      Text(
                        'Note',
                        style: TextStyle(
                          color: const Color(0xFF0D47A1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Add special instructions for the kitchen or staff',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100), // Space for fixed button
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom button
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity controls
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 24,
                          color: _quantity <= 1 ? Colors.grey : Colors.black,
                        ),
                        onPressed: _decrementQuantity,
                      ),
                      Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 24),
                        onPressed: _incrementQuantity,
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Add/Update button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveItem(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6835),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Text(
                            widget.cartItem == null ? 'Add' : 'Update',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.shopping_cart, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
