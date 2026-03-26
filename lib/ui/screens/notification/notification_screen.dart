import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/notification_provider.dart';
import 'package:queue_station_app/ui/screens/notification/view_model/notification_view_model.dart';
import 'package:queue_station_app/ui/screens/notification/widgets/notification_content.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(
        notificationProvider: context.read<NotificationProvider>(),
      ),
      child: const NotificationContent(),
    );
  }
}
