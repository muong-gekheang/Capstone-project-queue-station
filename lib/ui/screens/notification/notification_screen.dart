import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/notification_tile_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required bool isPushed});

  @override
  Widget build(BuildContext context) {
    final storeOrders = context
        .watch<StoreOrderNotificationProvider>()
        .queueEntries;

    return Scaffold(
      appBar: AppBarWidget(title: 'New Order'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: AppTheme.heading3,
                          color: AppTheme.naturalBlack,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.filter_alt_outlined,
                        color: AppTheme.naturalBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: storeOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return NotificationTileWidget(queueEntry: storeOrders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
