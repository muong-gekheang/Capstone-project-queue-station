import 'package:flutter/material.dart';
import 'package:queue_station_app/model/history.dart';
import 'package:queue_station_app/ui/widgets/order_card.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class HistoryViewScreen extends StatelessWidget {
  const HistoryViewScreen({super.key, required this.history});
  final History history;

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.sizeOf(context).width;

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
            TicketWidget(history: history),
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
