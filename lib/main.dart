import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/store/pages/store_main_screen.dart';

void main() {
  runApp(const QueueStationApp());
}

class QueueStationApp extends StatelessWidget {
  const QueueStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StoreMainScreen(),
    );
  }
}
