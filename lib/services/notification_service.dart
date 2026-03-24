import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/navigation_service.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin? _localNotifications = kIsWeb
      ? null
      : FlutterLocalNotificationsPlugin();

  static const String _vapidKey = String.fromEnvironment('VAPID_KEY');

  static const String _orderChannelId = 'order_channel';
  static const String _orderChannelName = 'Order Notifications';
  static const String _queueChannelId = 'queue_channel';
  static const String _queueChannelName = 'Queue Notifications';

  Future<void> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('User declined or has not granted permission');
      return;
    }

    String? token = await _fcm.getToken(
      vapidKey: _vapidKey,
    );
    debugPrint('FCM Token: $token');

    if (!kIsWeb) {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications!.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );
    }

    // Listen for foreground FCM messages
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // App launched from a terminated state via notification
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleRemoteNotificationTap(initialMessage);
      });
    }

    // App brought to foreground from background via notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleRemoteNotificationTap(message);
      });
    });
  }

  // ─── FCM foreground message handler ───────────────────────────────────────

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;
    final type = data['type'] ?? '';

    if (!kIsWeb && notification != null) {
      final isOrderType = type == 'new_order' || type == 'order_update';
      _localNotifications!.show(
        notification.title.hashCode ^ notification.body.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            isOrderType ? _orderChannelId : _queueChannelId,
            isOrderType ? _orderChannelName : _queueChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: type,
      );
    } else if (kIsWeb && notification != null) {
      debugPrint(
        'Web foreground notification: ${notification.title} - ${notification.body}',
      );
    }

    // For store-side order notifications, update the provider
    if ((type == 'new_order' || type == 'order_update') &&
        NavigationService.navigatorKey.currentContext != null) {
      final newEntry = QueueEntry(
        id: data['orderId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        queueNumber: data['queueNumber'] ?? 'A000',
        restId: data['restId'] ?? '',
        customerId: data['customerId'] ?? '',
        partySize: int.tryParse(data['partySize'] ?? '0') ?? 0,
        joinTime: DateTime.now(),
        status: QueueStatus.waiting,
        joinedMethod: JoinedMethod.remote,
        tableNumber: data['tableNumber'] ?? '',
      );
      Provider.of<StoreOrderNotificationProvider>(
        NavigationService.navigatorKey.currentContext!,
        listen: false,
      ).addIncomingOrder(newEntry);
    }
  }

  // ─── Local notification tap handler ───────────────────────────────────────

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    if (payload == 'queue_joined') {
      // Customer tapped their queue confirmation notification — just bring
      // the app to foreground; the ticket screen is already showing.
      debugPrint('Queue joined notification tapped');
    } else {
      // new_order or order_update → show the store's notification list
      _navigateToNotificationScreen();
    }
  }

  // ─── Remote notification tap handler ──────────────────────────────────────

  void _handleRemoteNotificationTap(RemoteMessage message) {
    final type = message.data['type'] ?? '';
    if (type == 'new_order' || type == 'order_update') {
      _navigateToNotificationScreen();
    } else if (type == 'queue_joined') {
      debugPrint('Queue joined remote notification tapped');
    }
  }

  // ─── Navigation helpers ────────────────────────────────────────────────────

  void _navigateToNotificationScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (NavigationService.isReady) {
        final navigator = NavigationService.navigatorKey.currentState!;
        // Pop any existing notification screen to avoid stacking duplicates
        if (navigator.canPop()) {
          navigator.popUntil((route) =>
              route.settings.name != '/notifications');
        }
        navigator.push(
          MaterialPageRoute(
            builder: (_) => const NotificationScreen(),
            settings: const RouteSettings(name: '/notifications'),
          ),
        );
      }
    });
  }

  // ─── Store-side notification triggers ─────────────────────────────────────

  /// Call this when the customer places a brand-new order.
  /// Updates the store's notification provider and shows a local banner.
  Future<void> notifyStoreOfNewOrder({
    required String tableNumber,
    required String queueNumber,
    required int itemCount,
    required String restId,
    required String customerId,
  }) async {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    final entry = QueueEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      queueNumber: queueNumber,
      restId: restId,
      customerId: customerId,
      partySize: 1,
      joinTime: DateTime.now(),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.remote,
      tableNumber: tableNumber,
    );

    // Update the in-app provider so the notification screen refreshes
    Provider.of<StoreOrderNotificationProvider>(ctx, listen: false)
        .addIncomingOrder(entry);

    // Show a system notification banner so the store sees it even when the
    // app is in the background or the screen is locked.
    if (!kIsWeb) {
      await _localNotifications?.show(
        int.tryParse(entry.id) ?? entry.id.hashCode,
        'New Order — Table $tableNumber',
        '$itemCount item${itemCount == 1 ? '' : 's'} ordered  •  Queue $queueNumber',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _orderChannelId,
            _orderChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: 'new_order',
      );
    }
  }

  /// Call this when the customer adds more items to an existing order.
  Future<void> notifyStoreOfOrderUpdate({
    required String tableNumber,
    required String queueNumber,
    required int itemCount,
    required String restId,
    required String customerId,
  }) async {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    final entry = QueueEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      queueNumber: queueNumber,
      restId: restId,
      customerId: customerId,
      partySize: 1,
      joinTime: DateTime.now(),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.remote,
      tableNumber: tableNumber,
    );

    Provider.of<StoreOrderNotificationProvider>(ctx, listen: false)
        .addIncomingOrder(entry);

    if (!kIsWeb) {
      await _localNotifications?.show(
        int.tryParse(entry.id) ?? entry.id.hashCode,
        'Order Updated — Table $tableNumber',
        '$itemCount item${itemCount == 1 ? '' : 's'} in updated order  •  Queue $queueNumber',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _orderChannelId,
            _orderChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: 'order_update',
      );
    }
  }

  // ─── Customer-side notification triggers ──────────────────────────────────

  /// Call this when the store accepts a customer's order.
  /// Shows a local banner so the customer knows their order has been accepted.
  Future<void> notifyCustomerOrderAccepted(QueueEntry entry) async {
    if (kIsWeb) return;

    await _localNotifications?.show(
      // Use a distinct id so it doesn't overwrite the queue-joined banner
      (int.tryParse(entry.id) ?? entry.id.hashCode) ^ 0x1,
      'Order Accepted!',
      'Your order for Table ${entry.tableNumber} (Queue #${entry.queueNumber}) has been accepted.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _queueChannelId,
          _queueChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'order_accepted',
    );
  }

  /// Call this immediately after the customer successfully joins the queue.
  /// Shows a local banner confirming their queue number and party size.
  Future<void> notifyCustomerQueueJoined(QueueEntry entry) async {
    if (kIsWeb) return;

    await _localNotifications?.show(
      int.tryParse(entry.id) ?? entry.id.hashCode,
      'You\'ve Joined the Queue!',
      'Queue #${entry.queueNumber}  •  Party of ${entry.partySize}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _queueChannelId,
          _queueChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'queue_joined',
    );
  }
}
