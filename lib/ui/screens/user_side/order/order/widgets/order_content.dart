import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/cart/view_model/cart_view_model.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';

class OrderContent extends StatelessWidget {
  const OrderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Your Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: vm.confirmedItems.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildOrderHeader(),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      itemCount: vm.confirmedItems.length,
                      separatorBuilder: (_, __) =>
                          const Divider(indent: 20, endIndent: 20),
                      itemBuilder: (context, index) {
                        final item = vm.confirmedItems[index];
                        final addOnsTotal = item.addOns.values.fold(
                          0.0,
                          (a, b) => a + b,
                        );

                        return FoodItemCard(
                          name: item.item.name,
                          item: item.item,
                          image: item.item.image,
                          size: item.size,
                          addons: item.addOns,
                          quantity: item.quantity,
                          note: item.note,
                          isEditable: false,
                          price:
                              (item.menuItemPrice + addOnsTotal) *
                              item.quantity,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

      bottomSheet: vm.confirmedItems.isEmpty
          ? null
          : _buildCheckoutButton(context),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[50],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Table No. B202",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Start Time: 8:40 PM",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleCheckout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6835),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Checkout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
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
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No orders yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.restaurant_menu),
            label: const Text(
              'Go to Menu',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6835),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Proceed to check out",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please proceed to check out and provide your table number to the cashier.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              "B202",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6835),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Return"),
          ),
        ],
      ),
    );
  }
}
