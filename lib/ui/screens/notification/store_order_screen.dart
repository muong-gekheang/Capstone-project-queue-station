import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';
import 'package:queue_station_app/ui/widgets/notification_tile_widget.dart';

class StoreOrderScreen extends StatefulWidget {
  final QueueEntry queueEntry;
  const StoreOrderScreen({super.key, required this.queueEntry});

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends State<StoreOrderScreen> {
  @override
  Widget build(BuildContext context) {
    // final QueueEntry queueEntry = widget.queueEntry;
    final provider = context.watch<StoreOrderNotificationProvider>();

    final queueEntry = provider.queueEntries.firstWhere(
      (e) => e.id == widget.queueEntry.id,
    );

    final allItems = queueEntry.order?.ordered ?? [];

    final pendingItems = allItems
        .where((item) => item.orderItemStatus == OrderItemStatus.pending)
        .toList();

    final acceptedItems = allItems
        .where((item) => item.orderItemStatus == OrderItemStatus.accepted)
        .toList();

    return Scaffold(
      appBar: AppBarWidget(title: '${queueEntry.tableNumber} Order'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  HeaderTile(title: 'New Order'),
                  const SizedBox(height: 10),
                  if (pendingItems.isNotEmpty) ...[
                    ...pendingItems.map(
                      (orderItem) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FoodItemCard(
                          name: orderItem.item.name,
                          item: orderItem.item,
                          addons: orderItem.addOns,
                          price: orderItem.menuItemPrice,
                          quantity: orderItem.quantity,
                          isEditable: false,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ButtonWidget(
                      title: 'Mark as accepted',
                      onPressed: () {
                        context
                            .read<StoreOrderNotificationProvider>()
                            .acceptAllIncomingOrder(queueEntry);
                      },
                      backgroundColor: AppTheme.primaryColor,
                      textColor: AppTheme.naturalWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      borderRadius: AppTheme.borderRadiusS,
                    ),
                  ] else ...[
                    InfoBadge(text: 'No New Order'),
                  ],

                  Divider(
                    color: AppTheme.naturalBlack,
                    thickness: 1, // thickness of the line
                    height: 20, // spacing around the divider
                  ),

                  HeaderTile(title: "Order"),
                  const SizedBox(height: 10),

                  if (acceptedItems.isNotEmpty)
                    ...acceptedItems.map(
                      (orderItem) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FoodItemCard(
                          name: orderItem.item.name,
                          item: orderItem.item,
                          addons: orderItem.addOns,
                          price: orderItem.menuItemPrice,
                          quantity: orderItem.quantity,
                          isEditable: false,
                        ),
                      ),
                    )
                  else
                    InfoBadge(text: 'No Accepted Orders'),
                ],
              ),
            ),
            ButtonWidget(
              title: 'Total',
              trailingText:
                  '\$${queueEntry.order?.calculateTotalPrice().toStringAsFixed(2)}',
              onPressed: () {},
              backgroundColor: AppTheme.primaryColor,
              textColor: AppTheme.naturalWhite,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderTile extends StatelessWidget {
  final String title;
  const HeaderTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppTheme.secondaryColor),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppTheme.heading3,
          color: AppTheme.naturalWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class InfoBadge extends StatelessWidget {
  final String text;
  const InfoBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppTheme.accentYellow),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.accentYellow,
          fontWeight: FontWeight.bold,
          fontSize: AppTheme.heading1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
