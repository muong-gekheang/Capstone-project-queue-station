import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/store_queue_history_detail.dart';

class StoreQueueHistoryCard extends StatelessWidget {
  final QueueEntry queueEntry;
  const StoreQueueHistoryCard({super.key, required this.queueEntry});

  String formattedtime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  String getUserName() {
    return mockUsers
        .firstWhere((user) => user.id == queueEntry.customerId)
        .name;
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
                  StoreQueueHistoryDetail(queueEntry: queueEntry),
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
                      getUserName(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Joined: ${formattedtime(queueEntry.joinTime)} | Seated: ${queueEntry.servedTime != null ? formattedtime(queueEntry.servedTime!) : '-'}',
                    ),
                    Text(queueEntry.status.name),
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
