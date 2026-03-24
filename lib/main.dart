import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  // Data-only FCM messages have no notification payload, so Android won't
  // show a system banner automatically — we must display one ourselves.
  // (Messages with a notification field are shown by Android automatically.)
  if (message.notification == null && !kIsWeb) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final data = message.data;
    final type = data['type'] ?? '';
    final isOrderType = type == 'new_order' || type == 'order_update';
    final channelId = isOrderType ? 'order_channel' : 'queue_channel';
    final channelName =
        isOrderType ? 'Order Notifications' : 'Queue Notifications';

    String title;
    String body;
    if (type == 'new_order') {
      final table = data['tableNumber'] ?? '';
      final queue = data['queueNumber'] ?? '';
      title = 'New Order${table.isNotEmpty ? ' — Table $table' : ''}';
      body = 'Queue $queue';
    } else if (type == 'order_update') {
      final table = data['tableNumber'] ?? '';
      final queue = data['queueNumber'] ?? '';
      title = 'Order Updated${table.isNotEmpty ? ' — Table $table' : ''}';
      body = 'Queue $queue';
    } else if (type == 'queue_joined') {
      final queue = data['queueNumber'] ?? '';
      title = 'New Queue Entry';
      body = queue.isNotEmpty ? 'Queue #$queue joined' : 'A customer joined the queue';
    } else {
      title = data['title'] ?? 'New Notification';
      body = data['body'] ?? '';
    }

    await plugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: type,
    );
  }
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
