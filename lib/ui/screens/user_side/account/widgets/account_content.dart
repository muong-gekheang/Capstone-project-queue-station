import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/view_models/account_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_screen.dart';

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AccountViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final customer = vm.currentCustomer;
    final profileLink = customer?.profileLink;
    print('customer name is: ${customer!.name}');
    print('profile link is: ${customer.profileLink}');
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
                child: profileLink != null && profileLink.isNotEmpty
                    ? Image.network(
                        profileLink,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[700],
                        ),
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
                  MaterialPageRoute(builder: (_) => HistoryScreen()),
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
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
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
          ],
        ),
      ),
    );
  }
}
