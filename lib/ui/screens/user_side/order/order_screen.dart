import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final confirmedOrders = orderProvider.orders;

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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
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
            ),
            const SizedBox(height: 16),

            Expanded(
              child: confirmedOrders.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (context, index) {
                        final order = confirmedOrders[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Header (ID)
                            Text(
                              "Order #${order.id.substring(order.id.length - 4)}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // The Items in this order
                            ...order.items.map(
                              (item) => FoodItemCard(
                                name: item.productName,
                                image: item.image,
                                size: item.sizeLabel,
                                addons: item.addons,
                                price: item.priceAtOrder,
                                quantity: item.quantity,
                                note: item.note,
                                isEditable: false,
                              ),
                            ),

                            const Divider(indent: 20, endIndent: 20),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomSheet: confirmedOrders.isEmpty
          ? null
          : Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _handleCheckout(context);
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
                    'Checkout',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.restaurant_menu, size: 20),
            label: const Text(
              'Go to Menu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  void _handleCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Proceed to check out",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Please proceed to check out and provide your table number to the cashier.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Text(
                  "B202",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6835),
                    letterSpacing: 1.2,
                  ),
                ),
              )
              
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(backgroundColor: Color(0xFF0D47A1)),
              child: Center(
                child: const Text(
                  "Return",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              )
              
              ),
            ),
          ],
        );
      },
    );
  }
}
