import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/manage/store_queue_screen.dart';

import '../ui/widgets/store_side_bottom_nav.dart';
import '../ui/screens/store_side/dashboard/dashboard_screen.dart';
import '../ui/screens/store_side/store_management/manage_store_screen.dart';
import '../ui/screens/store_side/settings/store_settings_screen.dart';

enum NavTab { dashboard, analytics, queue, settings }

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({super.key});

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  NavTab _selectedTab = NavTab.dashboard;

  List<Widget> get _screens => [
    DashboardScreen(),
    ManageStorePage(),
    StoreQueueScreen(),
    StoreSettingsScreen(),
  ];

  void _onTabSelected(NavTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  int _getTabIndex(NavTab tab) {
    switch (tab) {
      case NavTab.dashboard:
        return 0;
      case NavTab.analytics:
        return 1;
      case NavTab.queue:
        return 2;
      case NavTab.settings:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _getTabIndex(_selectedTab), children: _screens),
      bottomNavigationBar: BottomNavBar(
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
