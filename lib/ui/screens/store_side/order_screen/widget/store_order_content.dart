import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/store_side/order_screen/view_model/store_order_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/food_item_card.dart';

class StoreOrderContent extends StatefulWidget {
  final String queueEntryId;
  const StoreOrderContent({super.key, required this.queueEntryId});

  @override
  State<StoreOrderContent> createState() => _StoreOrderContentState();
}

class _StoreOrderContentState extends State<StoreOrderContent> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StoreOrderViewModel>();
    QueueEntry? queueEntry = vm.getQueueEntryById(widget.queueEntryId);
    return Scaffold(
      appBar: AppBarWidget(title: '${queueEntry?.tableNumber ?? ""} Order'),
      body: queueEntry != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: queueEntry.orderId == null
                  ? Text("No Order")
                  : FutureBuilder(
                      future: vm.getOrderDetailsById(queueEntry.orderId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        List<OrderItem> pendingItems =
                            snapshot.data?.ordered
                                .where(
                                  (e) =>
                                      e.orderItemStatus ==
                                      OrderItemStatus.pending,
                                )
                                .toList() ??
                            [];

                        List<OrderItem> acceptedItems =
                            snapshot.data?.ordered
                                .where(
                                  (e) =>
                                      e.orderItemStatus ==
                                      OrderItemStatus.accepted,
                                )
                                .toList() ??
                            [];

                        debugPrint("Order: ${snapshot.data}");

                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  HeaderTile(title: 'New Order'),
                                  const SizedBox(height: 10),
                                  if (pendingItems.isNotEmpty) ...[
                                    ...pendingItems.map(
                                      (orderItem) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: FoodItemCard(
                                          image: orderItem.item.image,
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
                                      title: vm.isLoading
                                          ? 'Processing'
                                          : 'Mark as accepted',
                                      onPressed: () {
                                        vm.acceptAllOrderItems(pendingItems);
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
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
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
                                  '\$${acceptedItems.fold(0.0, (previousValue, element) => previousValue + element.menuItemPrice)}',
                              onPressed: () {},
                              backgroundColor: AppTheme.primaryColor,
                              textColor: AppTheme.naturalWhite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 5,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            )
          : Center(child: Text("No Customer is in the table.")),
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
