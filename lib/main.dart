import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/food-ordering/provider/cart_provider.dart';
import 'package:queue_station_app/food-ordering/provider/order_provider.dart';
import 'package:queue_station_app/food-ordering/screens/menu_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const QueueStationApp(),
    )
  );
}
class QueueStationApp extends StatelessWidget {
  const QueueStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}
