import 'package:flutter/material.dart';
import 'package:queue_station_app/home_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchRestWidget(suggestionsList: ["Apple", "Tomb", "Void", "Train"]),
        Row(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text("Recent")),
            OutlinedButton(
              onPressed: () {},
              child: const Text("Sort by month"),
            ),
            OutlinedButton(onPressed: () {}, child: const Text("Sort by year")),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(home: Scaffold(body: HistoryScreen())));
}
