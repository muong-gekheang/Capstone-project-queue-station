import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/old_model/history.dart';
import 'package:queue_station_app/ui/widgets/order_card.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class HistoryViewScreen extends StatelessWidget {
  const HistoryViewScreen({super.key, required this.history});
  final History history;

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.sizeOf(context).width;
    String guestSuffix = history.guests > 1 ? "People" : "Person";

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
                              history.rest.name,
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
                                    history.rest.address,
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
                    history.queueId,
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
                        DateFormat("dd / MMM/ yyyy").format(history.queueDate),
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
                        DateFormat("h:mm:ss a").format(history.queueDate),
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
                        "${history.guests.toString()} $guestSuffix",
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
            OrderCard(
              image: "assets/home_screen/tori_rice.png",
              name: 'Spicy Tori Rice',
              addons: ["Kakedash Soup"],
              size: "Regular",
              price: 1,
              quantity: 2,
              isEditable: false,
              note:
                  "I want it to be very spicy and no onion please, thank you.",
            ),
            const SizedBox(height: 20),
            OrderCard(
              image: "assets/home_screen/tori_rice.png",
              name: 'Spicy Tori Rice',
              addons: ["Kakedash Soup"],
              size: "Regular",
              price: 1,
              quantity: 2,
              isEditable: false,
              note:
                  "I want it to be very spicy and no onion please, thank you.",
            ),
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
                    "\$5.50",
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
