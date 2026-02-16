import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/notification/store_order_screen.dart';

class NotificationTileWidget extends StatelessWidget {
  final QueueEntry queueEntry;
  final isNew = true;
  const NotificationTileWidget({super.key, required this.queueEntry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreOrderScreen(queueEntry: queueEntry),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppTheme.naturalBlack),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("New order from table ${queueEntry.tableNumber}"),
            ),
          ),
          if (isNew)
            Positioned(
              top: -10,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    "New",
                    style: TextStyle(
                      color: AppTheme.naturalWhite,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
