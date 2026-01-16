import 'package:flutter/material.dart';
import '../constants/enums.dart';

class NavRouter {
  static void handleTabSelection(
    BuildContext context,
    NavTab tab,
  ) {
    switch (tab) {
      case NavTab.dashboard:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case NavTab.analytics:
        Navigator.pushReplacementNamed(context, '/analytics');
        break;
      case NavTab.settings:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }
}
