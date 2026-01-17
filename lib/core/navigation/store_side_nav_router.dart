import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../../ui/store/pages/dashboard_screen.dart';
import '../../ui/store/pages/analytics_screen.dart';
import '../../ui/store/pages/store_settings_screen.dart';
import '../../ui/store/pages/manage_store_screen.dart';

class NavRouter {
  static void handleTabSelection(
    BuildContext context,
    NavTab tab,
  ) {
    Widget destination;
    switch (tab) {
      case NavTab.dashboard:
        destination = const DashboardScreen();
        break;
      case NavTab.analytics:
        destination = const ManageStorePage();
        break;
      case NavTab.settings:
        destination = const StoreSettingsScreen();
        break;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
