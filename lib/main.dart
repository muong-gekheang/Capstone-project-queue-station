import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/navigation_service.dart';
import 'package:queue_station_app/services/notification_service.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/firebase_options.dart'; 

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize local notifications + FCM listeners
  await NotificationService().init();

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
        navigatorKey: NavigationService
            .navigatorKey, // required for NavigationService.push()
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
