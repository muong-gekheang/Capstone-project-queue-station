import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/model/services/cart_provider.dart';
import 'package:queue_station_app/model/services/order_provider.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/normal_user_app.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';

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
            child: StoreMainScreen(),
          ),
        ),
      ),
    ),
  );
}
