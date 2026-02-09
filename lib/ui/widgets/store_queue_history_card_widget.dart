import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/model/store_queue_history.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/store_queue_history_detail.dart';

class StoreQueueHistoryCard extends StatelessWidget {
  final StoreQueueHistory storeQueueHistory;
  const StoreQueueHistoryCard({super.key, required this.storeQueueHistory});

  String formattedtime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StoreQueueHistoryDetail(storeQueueHistory: storeQueueHistory),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeQueueHistory.customerName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Joined: ${formattedtime(storeQueueHistory.joinedQueueTime)} | Seated: ${formattedtime(storeQueueHistory.seatedTime)}',
                    ),
                    Text(storeQueueHistory.currentStatus.name),
                  ],
                ),

                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
