import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/food-ordering/provider/cart_provider.dart';
import 'package:queue_station_app/food-ordering/provider/order_provider.dart';
import 'package:queue_station_app/food-ordering/screens/menu_screen.dart';
import 'package:queue_station_app/store_user_app.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/home/home_screen.dart';
import 'package:queue_station_app/normal_user_app.dart';
import 'package:queue_station_app/ui/store/pages/store_main_screen.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => CartProvider()),
//         ChangeNotifierProvider(create: (context) => OrderProvider()),
//       ],
//       child: const QueueStationApp(),
//     )
//   );
// }

// void main() {
//   runApp(
//     MaterialApp(
//       theme: AppTheme.lightTheme,
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(child: HomeScreenTest()),
//       ),
//     ),
//   );
// }


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            // child: NormalUserApp(),  
            // child: StoreUserApp(),
            child: StoreMainScreen(),
          ),
        ),
      ),
    ),
  );
}
