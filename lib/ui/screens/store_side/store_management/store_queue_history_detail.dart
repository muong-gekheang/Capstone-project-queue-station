import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/store_queue_history.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

class StoreQueueHistoryDetail extends StatelessWidget {
  final StoreQueueHistory storeQueueHistory;
  const StoreQueueHistoryDetail({super.key, required this.storeQueueHistory});

  Widget orderDetail() {
    if (storeQueueHistory.orderDetails.isEmpty) {
      return const Text('No orders');
    }
    return Column(
      children: storeQueueHistory.orderDetails.map((order) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(order.menuName),
            Text('${order.quantity}'),
            Text('\$${order.unitPrice.toStringAsFixed(2)}'),
          ],
        );
      }).toList(),
    );
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
                    storeQueueHistory.customerName,
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
                        storeQueueHistory.queueNumber,
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
                        storeQueueHistory.currentStatus.name,
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
                        storeQueueHistory.numberOfGuests.toString(),
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
                        ).format(storeQueueHistory.joinedQueueTime),
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
                              storeQueueHistory.joinedMethod ==
                                      JoinedMethod.remotely
                                  ? 'Remotely'
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
                              ).format(storeQueueHistory.joinedQueueTime),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Serving Time'),
                            Text(
                              DateFormat(
                                'h:mm a',
                              ).format(storeQueueHistory.seatedTime),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Serving End'),
                            Text(
                              DateFormat(
                                'h:mm a',
                              ).format(storeQueueHistory.endedTime),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Waiting Duration'),
                            Text(
                              storeQueueHistory.formatMMSS(
                                storeQueueHistory.waitingTime(),
                              ),
                            ),
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
