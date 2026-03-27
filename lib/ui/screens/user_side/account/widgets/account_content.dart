import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/notification/notification_message.dart';
import 'package:queue_station_app/services/notification_provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/notification_service.dart';
import 'package:queue_station_app/ui/screens/user_side/account/view_models/account_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_screen.dart';

class AccountContent extends StatefulWidget {
  const AccountContent({super.key});

  @override
  State<AccountContent> createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  QueueEntry _demoQueueEntry() {
    return QueueEntry(
      id: 'demo-${DateTime.now().millisecondsSinceEpoch}',
      queueNumber: 'Q-042',
      restId: 'demo-rest',
      customerId: 'demo-customer',
      partySize: 2,
      joinTime: DateTime.now(),
      status: QueueStatus.waiting,
      joinedMethod: JoinedMethod.remote,
      tableNumber: 'A-5',
      expectedTableReadyAt: DateTime.now().add(const Duration(minutes: 15)),
      assignedTableId: 'demo-table',
    );
  }

  void _fireTestNotifications(BuildContext context) {
    final provider = context.read<NotificationProvider>();

    // 1. Queue Joined — with rich lines
    provider.add(
      NotificationMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        body: 'Queue Q-042',
        type: 'queue_joined',
        receivedAt: DateTime.now(),
        richLines: [
          [
            NotificationSpan('You have successfully joined queue at '),
            NotificationSpan('Demo Restaurant', isHighlighted: true),
          ],
          [
            NotificationSpan('Your queue is: '),
            NotificationSpan('Q-042', isHighlighted: true),
          ],
          [
            NotificationSpan('The estimated waiting time is : '),
            NotificationSpan('15 mins', isHighlighted: true),
          ],
        ],
      ),
    );

    // 2. Order Accepted — with rich lines
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      provider.add(
        NotificationMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          title: '',
          body: 'Queue Q-042',
          type: 'order_accepted',
          receivedAt: DateTime.now(),
          richLines: [
            [
              NotificationSpan('Your current queue position: '),
              NotificationSpan('3', isHighlighted: true),
            ],
            [
              NotificationSpan('Your queue is: '),
              NotificationSpan('Q-042', isHighlighted: true),
            ],
            [
              NotificationSpan('The current queue is: '),
              NotificationSpan('Q-039', isHighlighted: true),
            ],
          ],
        ),
      );
      NotificationService().notifyCustomerOrderAccepted(
        _demoQueueEntry(),
      );
    });

    // 3. Queue Served — with rich lines
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      provider.add(
        NotificationMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
          title: "You're being served!",
          body: 'Queue Q-042',
          type: 'queue_served',
          receivedAt: DateTime.now(),
          richLines: [
            [
              NotificationSpan('Your queue: '),
              NotificationSpan('Q-042', isHighlighted: true),
              NotificationSpan(' is now being served'),
            ],
            [
              NotificationSpan('Table '),
              NotificationSpan('A-5', isHighlighted: true),
              NotificationSpan(' is ready for you'),
            ],
          ],
        ),
      );
    });

    NotificationService().notifyCustomerQueueJoined(
      _demoQueueEntry(),
      restaurantName: 'Demo Restaurant',
      estimatedWaitTime: '15 mins',
      queuePosition: 3,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Firing 3 test notifications (0s, 2s, 4s)...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AccountViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final customer = vm.currentCustomer;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  iconSize: 28,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF6835), width: 4),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 60, color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              customer?.name ?? "Unknown",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey, width: 2),
                ),
                overlayColor: const Color(0xFFF2F2F2),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, size: 32, color: Colors.black),
                  SizedBox(width: 12),
                  Text(
                    "Queue History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(221, 40, 40, 40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey, width: 2),
                ),
                overlayColor: const Color(0xFFF2F2F2),
              ),
              child: Row(
                children: const [
                  Icon(Icons.settings_outlined, size: 32, color: Colors.black),
                  SizedBox(width: 12),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(221, 40, 40, 40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => _fireTestNotifications(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFFFF6835),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active, size: 32, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    "Test Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
