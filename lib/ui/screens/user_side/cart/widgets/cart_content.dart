import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/ui/screens/user_side/order/cart/view_model/cart_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_item/menu_item_screen.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';

class CartContent extends StatelessWidget {
  const CartContent({super.key});

  Future<void> _confirmDelete(BuildContext context, OrderItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Confirm Delete",
          style: TextStyle(
            color: Color(0xffB22222),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Remove ${item.item.name} from the cart?"),
            SizedBox(
              width: 100,
              height: 100,
              child: item.item.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item.item.image!, fit: BoxFit.cover),
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
              foregroundColor: Colors.grey,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB22222),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Remove",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      context.read<CartViewModel>().removeItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();
    final cartItems = vm.items;

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Cart Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Table No. ${vm.tableNumber}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Start Time: ${vm.startTime}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 8),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Slidable(
                          key: ValueKey(item.hashCode),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Navigator.push<OrderItem>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MenuItemScreen(cartItem: item),
                                    ),
                                  );
                                },
                                backgroundColor: const Color(0xFF0D47A1),
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) => _confirmDelete(context, item),
                                backgroundColor: const Color(0xFFB22222),
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: FoodItemCard(
                            name: item.item.name,
                            item: item.item,
                            image: item.item.image,
                            size: item.size,
                            addons: item.addOns,
                            price:
                                (item.menuItemPrice +
                                    item.addOns.values.fold(
                                      0.0,
                                      (a, b) => a + b,
                                    )) *
                                item.quantity,
                            quantity: item.quantity,
                            note: item.note,
                            isEditable: true,
                            onIncrease: () => vm.increaseItem(item),
                            onDecrease: () => vm.decreaseItem(item),
                            onEdit: () {},
                          ),
                        );
                      },
                    ),
            ),

            // Bottom Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.items.isEmpty
                    ? null
                    : () => vm.confirmOrder(context), // only enabled if cart has items
                style: ElevatedButton.styleFrom(
                  backgroundColor: vm.items.isEmpty
                      ? Colors.grey.shade400
                      : const Color(0xFFFF6835),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Confirm Order ( \$${vm.totalAmount.toStringAsFixed(2)} )',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the menu screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MenuScreen(),
                ),
              );
            },
            icon: const Icon(Icons.restaurant),
            label: const Text("Go to Menu"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
