import 'package:flutter/material.dart';
import 'package:queue_station_app/models/notification/notification_message.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationMessage> _notifications = [];

  List<NotificationMessage> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void add(NotificationMessage message) {
    _notifications.insert(0, message);
    notifyListeners();
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notifications[index].isRead = true;
    notifyListeners();
  }
}
