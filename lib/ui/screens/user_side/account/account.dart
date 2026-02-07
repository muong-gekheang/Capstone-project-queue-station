import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_screen.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
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
                border: Border.all(color: Color(0xFFFF6835), width: 4),
              ),
              child: ClipOval(
                child: Image.asset('assets/images/girl.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Gek Heang",
              style: TextStyle(
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
                    builder: (context) {
                      return HistoryScreen();
                    },
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
                children: [
                  Icon(Icons.access_time, size: 32, color: Colors.black),
                  const SizedBox(width: 12),
                  const Text(
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
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
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
                children: [
                  Icon(Icons.settings_outlined, size: 32, color: Colors.black),
                  const SizedBox(width: 12),
                  const Text(
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
