import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_screen.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';
import 'package:queue_station_app/ui/widgets/norml_user_buttom_nav.dart';

enum NormalUserNavTab { home, map, foodOrdering, ticket, profile }

class NormalUserApp extends StatefulWidget {
  const NormalUserApp({super.key});

  @override
  State<NormalUserApp> createState() => _NormalUserAppState();
}

class _NormalUserAppState extends State<NormalUserApp> {
  NormalUserNavTab selectedTab = NormalUserNavTab.home;

  final List<Widget> screens = [
    HomeScreen(),
    Placeholder(), // MAP
    MenuScreen(),
    Placeholder(), // TICKET
    SettingsScreen(),
  ];


  void onTabSelected(NormalUserNavTab tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  int getIndex(NormalUserNavTab tab) {
    switch (tab) {
      case NormalUserNavTab.home:
        return 0;
      case NormalUserNavTab.map:
        return 1;
      case NormalUserNavTab.foodOrdering:
        return 2;
      case NormalUserNavTab.ticket:
        return 3;
      case NormalUserNavTab.profile:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: getIndex(selectedTab),
        children: screens,
      ),
      bottomNavigationBar: NormalUserButtomNav(
        selectedTab: selectedTab, 
        onTabSelected: onTabSelected)
    );
  }
}
