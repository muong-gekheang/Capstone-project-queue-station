import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/model/add_on.dart';
import 'package:queue_station_app/model/cart_item.dart';
import 'package:queue_station_app/model/menu_item.dart';
import 'package:queue_station_app/model/size_option.dart';
import 'package:queue_station_app/services/cart_provider.dart';

class MenuItemScreen extends StatefulWidget {
  final MenuItem? item;
  final CartItem? cartItem;

  const MenuItemScreen({super.key, this.item, this.cartItem})
    : assert(
        item != null || cartItem != null,
        'Either item or cartItem must be provided',
      );

  MenuItem get menuItem => item ?? cartItem!.menuItem;

  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  SizeOption? _selectedSize;
  final Map<AddOn, bool> _selectedAddOns = {};
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();

    _initializeAddOns();

    if (widget.cartItem != null) {
      _loadFromCartItem(widget.cartItem!);
    } else if (widget.item != null) {
      _selectedSize = widget.item!.defaultSize;
      _quantity = 1;
    }

    _calculateTotal();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _initializeAddOns() {
    for (var addOn in widget.menuItem.addOns) {
      _selectedAddOns[addOn] = false;
    }
  }

  void _loadFromCartItem(CartItem cartItem) {
    _selectedSize = cartItem.selectedSize;
    _quantity = cartItem.quantity;
    _noteController.text = cartItem.note;

    for (var addOn in cartItem.selectedAddOns) {
      _selectedAddOns[addOn] = true;
    }
  }

  void _calculateTotal() {
    final double mainPrice = _selectedSize?.price ?? widget.menuItem.basePrice;

    double addOnsPrice = 0;

    _selectedAddOns.forEach((addOn, isSelected) {
      if (isSelected) {
        addOnsPrice += addOn.price;
      }
    });

    setState(() {
      _totalPrice = (mainPrice + addOnsPrice) * _quantity;
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _calculateTotal();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _calculateTotal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.menuItem.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
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
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.menuItem.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text("From", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '\$${widget.menuItem.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6835),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  widget.menuItem.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    if (widget.menuItem.prepTimeMinutes != null)
                      Text(
                        'Preparation Time: ${widget.menuItem.prepTimeMinutes} minutes',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                  ],
                ),
                const SizedBox(height: 25),

                if (widget.menuItem.sizes.isNotEmpty) ...[
                  Text(
                    'Sizes',
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: widget.menuItem.sizes.map((size) {
                      return RadioListTile<SizeOption>(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                size.name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              '\$${size.price.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        value: size,
                        groupValue: _selectedSize,
                        onChanged: (value) {
                          setState(() {
                            _selectedSize = value;
                            _calculateTotal();
                          });
                        },
                        controlAffinity:
                            ListTileControlAffinity.trailing, // radio on right
                        activeColor: Color(0xFFFF6835),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 25),
                ],

                if (widget.menuItem.addOns.isNotEmpty) ...[
                  Text(
                    'Add-ons',
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
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
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      '\$${addOn.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                value: _selectedAddOns[addOn] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAddOns[addOn] = value ?? false;
                                    _calculateTotal();
                                  });
                                },
                                checkboxShape: const CircleBorder(),
                                secondary: addOn.image != null
                                    ? CircleAvatar(
                                        backgroundImage: AssetImage(
                                          addOn.image!,
                                        ),
                                        radius: 20,
                                        backgroundColor: Colors.grey.shade200,
                                      )
                                    : null,
                                activeColor: Colors.blue,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        )
                        .toList(),
                  ),

                  SizedBox(height: 25),
                ],

                Text(
                  'Note',
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Add special instructions for the kitchen or staff',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
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
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, size: 24),
                        onPressed: _decrementQuantity,
                      ),
                      Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          '$_quantity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 24),
                        onPressed: _incrementQuantity,
                      ),
                    ],
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = context.read<CartProvider>();
                        List<AddOn> selectedAddOnsList = _selectedAddOns.entries
                            .where((entry) => entry.value == true)
                            .map((entry) => entry.key)
                            .toList();
                        CartItem newItem = CartItem(
                          id: widget.cartItem?.id,
                          menuItem: widget.menuItem,
                          selectedSize:
                              _selectedSize ?? widget.menuItem.defaultSize,
                          selectedAddOns: selectedAddOnsList,
                          quantity: _quantity,
                          note: _noteController.text,
                        );

                        widget.cartItem == null
                            ? cart.addToCart(newItem)
                            : cart.updateCartItem(newItem);

                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            backgroundColor: const Color(0xFF10B981),
                            content: widget.cartItem == null
                                ? Text(
                                    "${widget.menuItem.name} added to cart!",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "${widget.menuItem.name} edited successfully",
                                    style: const TextStyle(color: Colors.white),
                                  ),

                            actions: const [SizedBox.shrink()],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        );

                        Future.delayed(const Duration(seconds: 2), () {
                          ScaffoldMessenger.of(
                            context,
                          ).hideCurrentMaterialBanner();
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF6835),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          widget.cartItem == null
                              ? Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                          SizedBox(width: 8),
                          Icon(Icons.shopping_cart, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
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
