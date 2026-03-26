import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:queue_station_app/models/notification/notification_message.dart';
import 'package:queue_station_app/services/navigation_service.dart';
import 'package:queue_station_app/services/notification_provider.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';

/// ─────────────────────────────────────────
/// Background Handler (REQUIRED)
/// ─────────────────────────────────────────
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

/// ─────────────────────────────────────────
/// Notification Service
/// ─────────────────────────────────────────
class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin? _localNotifications =
      kIsWeb ? null : FlutterLocalNotificationsPlugin();

  static const String _vapidKey = String.fromEnvironment('VAPID_KEY');

  static const String _orderChannelId = 'order_channel';
  static const String _orderChannelName = 'Order Notifications';

  static const String _queueChannelId = 'queue_channel';
  static const String _queueChannelName = 'Queue Notifications';

  String? _fcmToken;

  /// ─────────────────────────────────────────
  /// INIT
  /// ─────────────────────────────────────────
  Future<void> init() async {
    // Request permission
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('Notification permission denied');
      return;
    }

    // Get and store token
    _fcmToken = await _fcm.getToken(vapidKey: _vapidKey);
    debugPrint('FCM Token: $_fcmToken');

    if (!kIsWeb) {
      await _initLocalNotifications();
      await _createNotificationChannels();
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // App opened from terminated
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteTap(initialMessage);
    }

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteTap);
  }

  /// Save the device FCM token to the user's Firestore document.
  /// Call this after the user successfully logs in or restores session.
  Future<void> saveTokenForUser(String userId) async {
    if (_fcmToken == null || userId.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': _fcmToken});
      debugPrint('FCM token saved for user $userId');
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  /// ─────────────────────────────────────────
  /// LOCAL NOTIFICATION SETUP
  /// ─────────────────────────────────────────
  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications!.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onLocalTap,
    );
  }

  Future<void> _createNotificationChannels() async {
    const orderChannel = AndroidNotificationChannel(
      _orderChannelId,
      _orderChannelName,
      importance: Importance.high,
    );

    const queueChannel = AndroidNotificationChannel(
      _queueChannelId,
      _queueChannelName,
      importance: Importance.high,
    );

    final androidPlugin = _localNotifications!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(orderChannel);
    await androidPlugin?.createNotificationChannel(queueChannel);
  }

  /// ─────────────────────────────────────────
  /// FOREGROUND HANDLER
  /// ─────────────────────────────────────────
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;
    final type = data['type'] ?? '';

    final title = notification?.title ?? data['title'] ?? '';
    final body = notification?.body ?? data['body'] ?? '';

    if (title.isNotEmpty || body.isNotEmpty) {
      // Use rich-line format for customer-facing notification types
      if (type == 'order_accepted') {
        _addOrderAcceptedToProvider(data);
      } else if (type == 'queue_served') {
        _addQueueServedToProvider(data);
      } else {
        _addToNotificationProvider(title: title, body: body, type: type);
      }
      _showInAppBanner(title: title, body: body, type: type);
    }

    // OS-level notification for mobile/desktop (not needed on web)
    if (!kIsWeb && notification != null) {
      final isOrder = _isOrderType(type);

      _localNotifications!.show(
        id: _generateId(),
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            isOrder ? _orderChannelId : _queueChannelId,
            isOrder ? _orderChannelName : _queueChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: type,
      );
    }

    if (_isOrderType(type)) {
      _updateOrderProvider(data);
    }
  }

  void _addOrderAcceptedToProvider(Map<String, dynamic> data) {
    final queueNumber = data['queueNumber'] ?? '';
    final position = data['position'] ?? '';
    final currentQueue = data['currentQueue'] ?? '';

    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    Provider.of<NotificationProvider>(ctx, listen: false).add(
      NotificationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        body: 'Queue $queueNumber',
        type: 'order_accepted',
        receivedAt: DateTime.now(),
        richLines: [
          [
            NotificationSpan('Your current queue position: '),
            NotificationSpan(position, isHighlighted: true),
          ],
          [
            NotificationSpan('Your queue is: '),
            NotificationSpan(queueNumber, isHighlighted: true),
          ],
          if (currentQueue.isNotEmpty) ...[
            [
              NotificationSpan('The current queue is: '),
              NotificationSpan(currentQueue, isHighlighted: true),
            ],
          ],
        ],
      ),
    );
  }

  void _addQueueServedToProvider(Map<String, dynamic> data) {
    final queueNumber = data['queueNumber'] ?? '';
    final tableNumber = data['tableNumber'] ?? '';

    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    Provider.of<NotificationProvider>(ctx, listen: false).add(
      NotificationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "You're being served!",
        body: 'Queue $queueNumber',
        type: 'queue_served',
        receivedAt: DateTime.now(),
        richLines: [
          [
            NotificationSpan('Your queue: '),
            NotificationSpan(queueNumber, isHighlighted: true),
            NotificationSpan(' is now being served'),
          ],
          if (tableNumber.isNotEmpty) ...[
            [
              NotificationSpan('Table '),
              NotificationSpan(tableNumber, isHighlighted: true),
              NotificationSpan(' is ready for you'),
            ],
          ],
        ],
      ),
    );
  }

  void _showInAppBanner({
    required String title,
    required String body,
    required String type,
  }) {
    final messenger = NavigationService.scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        padding: EdgeInsets.zero,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Transparent so our custom Container controls all styling
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: const Border(
              left: BorderSide(color: Color(0xFFFF6835), width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6835).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Color(0xFFFF6835),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: const TextStyle(
                          color: Color(0xFF6C6C6C),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (_isOrderType(type)) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    messenger.hideCurrentSnackBar();
                    _navigateToNotificationScreen();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ─────────────────────────────────────────
  /// TAP HANDLERS
  /// ─────────────────────────────────────────
  void _onLocalTap(NotificationResponse response) {
    final payload = response.payload ?? '';

    if (_isOrderType(payload)) {
      _navigateToNotificationScreen();
    }
  }

  void _handleRemoteTap(RemoteMessage message) {
    final type = message.data['type'] ?? '';
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    if (title.isNotEmpty || body.isNotEmpty) {
      _addToNotificationProvider(title: title, body: body, type: type);
    }

    _navigateToNotificationScreen();
  }

  void _addToNotificationProvider({
    required String title,
    required String body,
    required String type,
  }) {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    Provider.of<NotificationProvider>(ctx, listen: false).add(
      NotificationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        receivedAt: DateTime.now(),
      ),
    );
  }

  /// ─────────────────────────────────────────
  /// NAVIGATION
  /// ─────────────────────────────────────────
  void _navigateToNotificationScreen() {
    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute(
        builder: (_) => const NotificationScreen(),
        settings: const RouteSettings(name: '/notifications'),
      ),
    );
  }

  /// ─────────────────────────────────────────
  /// STORE NOTIFICATIONS (local / programmatic)
  /// ─────────────────────────────────────────
  Future<void> notifyStoreOfNewOrder({
    required String orderId,
    required int itemCount,
  }) async {
    const title = 'New Order';
    final body = '$itemCount confirmed item${itemCount == 1 ? '' : 's'}';

    _addToNotificationProvider(title: title, body: body, type: 'new_order');

    if (!kIsWeb) {
      await _showNotification(
        id: orderId,
        title: title,
        body: body,
        payload: 'new_order',
        isOrder: true,
      );
    }
  }

  Future<void> notifyStoreOfOrderUpdate({
    required String orderId,
    required int itemCount,
  }) async {
    const title = 'Order Updated';
    final body = '$itemCount item${itemCount == 1 ? '' : 's'} in order';

    _addToNotificationProvider(title: title, body: body, type: 'order_update');

    if (!kIsWeb) {
      await _showNotification(
        id: orderId,
        title: title,
        body: body,
        payload: 'order_update',
        isOrder: true,
      );
    }
  }

  /// ─────────────────────────────────────────
  /// CUSTOMER NOTIFICATIONS (local / programmatic)
  /// ─────────────────────────────────────────

  /// Call this immediately after the customer successfully joins a queue.
  Future<void> notifyCustomerQueueJoined(
    QueueEntry entry, {
    String restaurantName = '',
    String estimatedWaitTime = '',
    String? restaurantLogoUrl,
    int queuePosition = 0,
  }) async {
    final queueNum = entry.queueNumber;

    final richLines = <List<NotificationSpan>>[
      if (restaurantName.isNotEmpty) ...[
        [
          NotificationSpan('You have successfully joined queue at '),
          NotificationSpan(restaurantName, isHighlighted: true),
        ],
      ] else ...[
        [NotificationSpan('You have successfully joined the queue')],
      ],
      [
        NotificationSpan('Your queue is: '),
        NotificationSpan(queueNum, isHighlighted: true),
      ],
      if (estimatedWaitTime.isNotEmpty) ...[
        [
          NotificationSpan('The estimated waiting time is : '),
          NotificationSpan(estimatedWaitTime, isHighlighted: true),
        ],
      ],
    ];

    _addToNotificationProviderWithRichLines(
      title: '',
      body: 'Queue $queueNum',
      type: 'queue_joined',
      richLines: richLines,
      imageUrl: restaurantLogoUrl,
    );

    if (kIsWeb) return;

    await _showNotification(
      id: entry.id,
      title: 'Joined Queue',
      body: restaurantName.isNotEmpty
          ? 'Queue #$queueNum at $restaurantName'
          : 'Queue #$queueNum • Party ${entry.partySize}',
      payload: 'queue_joined',
      isOrder: false,
    );
  }

  Future<void> notifyCustomerOrderAccepted(QueueEntry entry) async {
    if (kIsWeb) return;

    await _showNotification(
      id: entry.id,
      title: 'Order Accepted',
      body:
          'Table ${entry.tableNumber} (Queue #${entry.queueNumber}) accepted',
      payload: 'order_accepted',
      isOrder: false,
    );
  }

  /// ─────────────────────────────────────────
  /// HELPERS
  /// ─────────────────────────────────────────
  void _addToNotificationProviderWithRichLines({
    required String title,
    required String body,
    required String type,
    required List<List<NotificationSpan>> richLines,
    String? imageUrl,
  }) {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    Provider.of<NotificationProvider>(ctx, listen: false).add(
      NotificationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        receivedAt: DateTime.now(),
        richLines: richLines,
        imageUrl: imageUrl,
      ),
    );
  }

  Future<void> _showNotification({
    required String id,
    required String title,
    required String body,
    required String payload,
    required bool isOrder,
  }) async {
    await _localNotifications?.show(
      id: int.tryParse(id) ?? id.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          isOrder ? _orderChannelId : _queueChannelId,
          isOrder ? _orderChannelName : _queueChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  int _generateId() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  bool _isOrderType(String type) {
    return type == 'new_order' || type == 'order_update';
  }

  void _updateOrderProvider(Map<String, dynamic> data) {
    final ctx = NavigationService.navigatorKey.currentContext;
    if (ctx == null) return;

    final entry = QueueEntry(
      id: data['orderId'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      queueNumber: data['queueNumber'] ?? '',
      restId: data['restId'] ?? '',
      customerId: data['customerId'] ?? '',
      partySize: int.tryParse(data['partySize'] ?? '1') ?? 1,
      joinTime: DateTime.now(),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.remote,
      tableNumber: data['tableNumber'] ?? '',
      expectedTableReadyAt:
          DateTime.now().add(const Duration(minutes: 10)),
      assignedTableId: '',
    );

    Provider.of<StoreOrderNotificationProvider>(
      ctx,
      listen: false,
    ).addIncomingOrder(entry);
  }
}
