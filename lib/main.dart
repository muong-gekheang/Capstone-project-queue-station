import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/menu_management.dart';
import 'package:queue_station_app/ui/screens/store_queue_history.dart';

void main() {
  runApp(const QueueStationApp());
}

class QueueStationApp extends StatelessWidget {
  const QueueStationApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Queue Station",
      home: Center(
        child: ConstrainedBox(constraints: 
        const BoxConstraints(
          maxWidth: 390
        ),
        // child: const MenuManagement(),       
        child: const StoreQueueHistory(), 
        ),
      ),
    );
  }

}
