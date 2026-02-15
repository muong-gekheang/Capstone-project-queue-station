import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/notification_tile_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, });

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 15),
            NotificationTileWidget(isNew: true),
            SizedBox(height: 15),
            NotificationTileWidget(isNew: false),
            SizedBox(height: 15),
            NotificationTileWidget(isNew: true),
            SizedBox(height: 15),
            NotificationTileWidget(isNew: true),
            SizedBox(height: 15),
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
