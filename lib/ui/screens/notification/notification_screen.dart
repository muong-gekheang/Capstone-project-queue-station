import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/notification_tile_widget.dart';

class NotificationScreen extends StatelessWidget {
  
  const NotificationScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    final storeOrders = context
        .watch<StoreOrderNotificationProvider>()
        .queueEntries;
    
    debugPrint('StoreOrders length: ${storeOrders.length}');

    for (var order in storeOrders) {
      debugPrint('Queue: ${order.queueNumber}');
      debugPrint('Table: ${order.tableNumber}');
      debugPrint('Items: ${order.order?.inCart.length}');
      debugPrint('-------------------');
    }

    return Scaffold(
      appBar: AppBarWidget(title: 'New Order',),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: (){},
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      Text("Filter", style: TextStyle(fontSize: AppTheme.heading3, color: AppTheme.naturalBlack),),
                      SizedBox(width: 5),
                      Icon(Icons.filter_alt_outlined, color: AppTheme.naturalBlack,),
                    ],
                  )
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: storeOrders.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
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

Widget get _filterWidget {
  return TextButton(
    onPressed: () {},
    child: Text(
      'Filter',
      style: TextStyle(
        color: AppTheme.secondaryColor,
        fontSize: AppTheme.heading2,
      ),
    ),
  );
}
