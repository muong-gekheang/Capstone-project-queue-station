import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/user/mock/mock_user_data.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

class StoreQueueHistoryDetail extends StatelessWidget {
  final QueueEntry queueEntry;
  const StoreQueueHistoryDetail({super.key, required this.queueEntry});

  String getUserName() {
    try {
      return mockUsers
          .firstWhere((user) => user.id == queueEntry.customerId)
          .name;
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget orderDetail() {
    // Placeholder until orders are integrated
    return const Text('Order details not available');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Customer Details', color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getUserName(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Queue Number:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        queueEntry.queueNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Current Status:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        queueEntry.status.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Number of Guest(s):',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        queueEntry.partySize.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Joined:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat(
                          'dd/ MMM / yyyy, hh:mm a',
                        ).format(queueEntry.joinTime),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(13, 71, 161, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Queue Information',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Join Queue Method'),
                            Text(
                              queueEntry.joinedMethod == JoinedMethod.remote
                                  ? 'Remote'
                                  : 'Walk-in',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Joined Queue Time'),
                            Text(
                              DateFormat(
                                'dd MMM yyyy, h:mm a',
                              ).format(queueEntry.joinTime),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Serving Time'),
                            Text(
                              queueEntry.servedTime != null
                                  ? DateFormat(
                                      'h:mm a',
                                    ).format(queueEntry.servedTime!)
                                  : '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Serving End'),
                            Text(
                              queueEntry.endedTime != null
                                  ? DateFormat(
                                      'h:mm a',
                                    ).format(queueEntry.endedTime!)
                                  : '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Waiting Duration'),
                            Text(queueEntry.waitingTimeText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(13, 71, 161, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Order Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
