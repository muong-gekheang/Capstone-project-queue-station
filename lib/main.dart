import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart'; // ✅ added
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';
import 'package:queue_station_app/models/user/store_user.dart';

void main() {
  final mockStoreUser = StoreUser(
    id: 'mock-store-1',
    name: 'Test Store',
    email: 'store@test.com',
    phone: '0123456789',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(
            currentOrder: Order(id: '', timestamp: DateTime.now()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => StoreOrderNotificationProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: StoreMainScreen(user: mockStoreUser)),
        ),
      ),
    ),
  );
}
