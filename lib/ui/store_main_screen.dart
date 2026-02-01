import 'package:flutter/material.dart';

import '../../../widgets/store_side_bottom_nav.dart';
import 'dashboard_screen.dart';
import 'manage_store_screen.dart';
import 'store_settings_screen.dart';

enum NavTab { dashboard, analytics, settings }

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({super.key});

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  NavTab _selectedTab = NavTab.dashboard;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ManageStorePage(),
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
      case NavTab.settings:
        return 2;
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
