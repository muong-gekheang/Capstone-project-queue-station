import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:queue_station_app/food-ordering/screens/menu_screen.dart';
import 'package:queue_station_app/model/restaurant.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/home/join_queue_screen.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:queue_station_app/user-setting/settings_screen.dart';
class NormalUserApp extends StatefulWidget {
  const NormalUserApp({super.key});

  @override
  State<NormalUserApp> createState() => _NormalUserAppState();
}

class _NormalUserAppState extends State<NormalUserApp> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),      // your current HomeScreen content goes here
    // MapScreen(),     // create MapScreen separately
    MenuScreen(),  // create OrdersScreen separately
    // TicketScreen(),  // create TicketConfirmationScreen separately
    SettingsScreen(), // create ProfileScreen separately
  ];

  final List<String> iconPaths = [
    'assets/images/home_icon.svg',
    'assets/images/map_icon.svg',
    'assets/images/food_ordering_icon.svg',
    'assets/images/ticket_confirmation.svg',
    'assets/images/profile_icon.svg',
  ];

  final List<String> labels = [
    'Home',
    'Map',
    'Orders',
    'Ticket',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(iconPaths.length, (index) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              iconPaths[index],
              colorFilter: ColorFilter.mode(
                index == selectedIndex ? Colors.orange : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: labels[index],
          );
        }),
      ),
    );
  }
}
 