import 'package:flutter/material.dart';
import 'package:queue_station_app/models/notification/notification_message.dart';
import 'package:queue_station_app/services/notification_provider.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationProvider _notificationProvider;

  NotificationViewModel({required NotificationProvider notificationProvider})
      : _notificationProvider = notificationProvider {
    _notificationProvider.addListener(_onChanged);
  }

  void _onChanged() => notifyListeners();

  List<NotificationMessage> get notifications =>
      _notificationProvider.notifications;

  int get unreadCount => _notificationProvider.unreadCount;

  void markAllRead() => _notificationProvider.markAllRead();

  void markRead(String id) => _notificationProvider.markRead(id);

  @override
  void dispose() {
    _notificationProvider.removeListener(_onChanged);
    super.dispose();
  }
}
