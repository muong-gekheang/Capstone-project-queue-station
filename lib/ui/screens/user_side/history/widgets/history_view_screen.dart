import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/history/view_models/history_view_model.dart';
import 'package:queue_station_app/ui/widgets/order_card.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class HistoryViewScreen extends StatelessWidget {
  const HistoryViewScreen({super.key, required this.history});
  final QueueEntry history;

  @override
  Widget build(BuildContext context) {
    final historyVM = context.watch<HistoryViewModel>();
    final restaurant = historyVM.getRestaurant(history.restId);
    final order = history.orderId != null ? historyVM.getOrder(history.orderId!) : null;
    final totalPrice = historyVM.getTotalPriceForQueueEntry(history.id);

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("History")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (historyVM.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("History")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    double screenSize = MediaQuery.sizeOf(context).width;
    String guestSuffix = history.partySize > 1 ? "People" : "Person";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: ListView(
          children: [
            TicketWidget(
              topContent: Column(
                children: [
                  Row(
                    spacing: 13,
                    children: [
                      SizedBox.square(
                        dimension: 70,
                        child: Image.asset("assets/home_screen/kungfu.png"),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10,
                          children: [
                            Text(
                              restaurant.name,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                Expanded(
                                  child: Text(
                                    restaurant.address,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Queue Number",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    history.id.substring(0, 4),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              bottomContent: Column(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    history.status.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      Text(
                        DateFormat("dd / MMM/ yyyy").format(history.joinTime),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Joined queue time",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        DateFormat("h:mm:ss a").format(history.joinTime),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Number of Guest(s)",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        "${history.partySize.toString()} $guestSuffix",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize * 0.1),
              child: Divider(
                thickness: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Center(
              child: Text(
                "Orders",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (order != null)
              ...order.ordered.map((item) {
                final menuItem = historyVM.menuItems[item.menuItemId];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: OrderCard(
                    image: menuItem?.image ?? "assets/default.png",
                    name: menuItem?.name ?? "Unknown Item",
                    addons: item.addOns.keys.toList(),
                    size: item.sizeName,
                    price: item.menuItemPrice,
                    quantity: item.quantity,
                    isEditable: false,
                    note: item.note,
                  ),
                );
              }),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: screenSize * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
