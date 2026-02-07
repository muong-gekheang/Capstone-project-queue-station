import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/old_model/user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/confirm_ticket_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/instruction.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/norml_user_buttom_nav.dart';

enum NormalUserNavTab { home, map, foodOrdering, ticket, profile }

final List<Widget> screens = [
  HomeScreen(),
  Placeholder(), // MAP
  Instruction(),
  Placeholder(), // TICKET
  Account(),
];

class NormalUserApp extends StatefulWidget {
  const NormalUserApp({super.key});

  @override
  State<NormalUserApp> createState() => _NormalUserAppState();
}

class _NormalUserAppState extends State<NormalUserApp> {
  NormalUserNavTab selectedTab = NormalUserNavTab.home;

  Future<void> onTabSelected(NormalUserNavTab tab) async {
    User? user = context.read<UserProvider>().currentUser;
    if (tab != NormalUserNavTab.ticket) {
      setState(() {
        selectedTab = tab;
      });
    } else {
      if (user != null && user.isJoinedQueue) {
        context.go("/ticket");
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: "Oops, A problem!",
              content: Column(
                children: [
                  Text(
                    "Please make sure to join a queue first, so you can see your ticket.",
                  ),
                ],
              ),
              actions: [],
            );
          },
        );
      }
    }
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
      body: SafeArea(
        child: IndexedStack(index: getIndex(selectedTab), children: screens),
      ),
      bottomNavigationBar: NormalUserButtomNav(
        selectedTab: selectedTab,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
