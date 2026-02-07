import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/model/cart_item.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_item_screen.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, CartItem item) async{
    final shouldDelete = await showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Confirm Delete",
            style: TextStyle(
              color: Color(0xffB22222),
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Are you sure you want to Remove ${item.menuItem.name} from the cart?"),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: item.menuItem.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item.menuItem.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.restaurant, color: Colors.grey[400]),
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey
              ),
              child: const Text("Cancel", style: TextStyle( fontWeight: FontWeight.bold),)
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB22222),
                foregroundColor: Colors.white
              ),
              child: const Text("Remove", style: TextStyle( fontWeight: FontWeight.bold),)
            ),
          ],
        );
      }
    );

    if (shouldDelete == true) {
      context.read<CartProvider>().removeItem(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Your Order Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Table No. B202",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Start Time: 8:40 PM",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order List",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xFF0D47A1),
                    ),
                    label: const Text(
                      "Add Item",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D47A1),
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 8),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return Slidable(
                          key: ValueKey(cartItem.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push<CartItem>(
                                    context,
                                    MaterialPageRoute(builder: (_) => MenuItemScreen(cartItem: cartItem,)),
                                  );
                                },
                                backgroundColor: const Color(0xFF0D47A1),
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  _confirmDelete(context, cartItem);
                                },
                                backgroundColor: const Color(0xFFB22222),
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: FoodItemCard(
                            name: cartItem.menuItem.name,
                            image: cartItem.menuItem.image,
                            size: cartItem.selectedSize?.name,
                            addons: {
                              for (final addon in cartItem.selectedAddOns)
                                addon.name: addon.price,
                            },

                            price: cartItem.totalItemPrice,
                            quantity: cartItem.quantity,
                            note: cartItem.note.isNotEmpty ? cartItem.note : null,
                            isEditable: true,
                            onEdit: () {},
                            onIncrease: () {
                              cartProvider.updateQuantity(cartItem.id, cartItem.quantity + 1);
                            },
                            onDecrease: () {
                              if (cartItem.quantity > 1) {
                                cartProvider.updateQuantity(cartItem.id, cartItem.quantity - 1);
                              }
                            },
                          )
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
      bottomSheet: cartItems.isEmpty 
        ? null 
        : Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _handleConfirmOrder(context, cartProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6835),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                      'Confirm Order ( \$${cartProvider.totalAmount.toStringAsFixed(2)} )',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ),
            ),
        )
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from the menu to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.restaurant_menu, size: 20),
            label: const Text(
              'Browse Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6835),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _handleConfirmOrder(BuildContext context, CartProvider cart) {
    final orderProvider = context.read<OrderProvider>();
    if (cart.items.isNotEmpty) {
      orderProvider.addOrder(cart.items, cart.totalAmount);
    }
    cart.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text(
              "Order placed successfully",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}