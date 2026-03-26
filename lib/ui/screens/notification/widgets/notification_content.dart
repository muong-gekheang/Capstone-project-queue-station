import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/notification/view_model/notification_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/notification_tile_widget.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final notifications = vm.notifications;

    return Scaffold(
      appBar: AppBarWidget(title: 'Notifications'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (vm.unreadCount > 0)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: vm.markAllRead,
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontSize: AppTheme.heading3,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: AppTheme.naturalBlack.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                              color: AppTheme.naturalBlack.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return GestureDetector(
                          onTap: () => vm.markRead(notif.id),
                          child: NotificationTileWidget(notification: notif),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
