import 'package:flutter/material.dart';
import 'package:queue_station_app/data/mock/store_queue_history_data.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

class StoreQueueHistoryDetail extends StatelessWidget {
  final QueueEntry queueEntry;
  const StoreQueueHistoryDetail({super.key, required this.queueEntry});

  String getUserName() {
    return mockUsers
        .firstWhere((user) => user.id == queueEntry.customerId)
        .name;
  }

  Widget orderDetail() {
    if (queueEntry.order != null && queueEntry.order!.ordered.isNotEmpty) {
      return Column(
        children: queueEntry.order!.ordered.map((orderItem) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderItem.item.name),
              Text(orderItem.quantity.toString()),
              Text('\$${orderItem.menuItemPrice.toStringAsFixed(2)}'),
            ],
          );
        }).toList(),
      );
    } else {
      return const Text('No orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Customer Details', color: Colors.black),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getUserName(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Queue Number:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 10),
                      Text(
                        queueEntry.queueNumber,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Current Status:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 10),
                      Text(
                        queueEntry.status.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Number of Guest(s):',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 10),
                      Text(
                        queueEntry.partySize.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Joined:', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 10),
                      Text(
                        DateFormat(
                          'dd/ MMM / yyyy, hh:mm a',
                        ).format(queueEntry.joinTime),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(13, 71, 161, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Queue Information',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Join Queue Method'),
                            Text(
                              queueEntry.joinedMethod == JoinedMethod.remote
                                  ? 'Remote'
                                  : 'Walk-in',
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Joined Queue Time'),
                            Text(
                              DateFormat(
                                'dd MMM yyyy, h:mm a',
                              ).format(queueEntry.joinTime),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Serving Time'),
                            Text(
                              queueEntry.servedTime != null
                                  ? DateFormat(
                                      'h:mm a',
                                    ).format(queueEntry.servedTime!)
                                  : '-',
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Serving End'),
                            Text(
                              queueEntry.servedTime != null
                                  ? DateFormat(
                                      'h:mm a',
                                    ).format(queueEntry.endedTime!)
                                  : '-',
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Waiting Duration'),
                            Text(queueEntry.waitingTimeText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(13, 71, 161, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Order Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: orderDetail(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
