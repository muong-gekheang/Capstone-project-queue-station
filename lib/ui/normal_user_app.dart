import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/instruction_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/norml_user_buttom_nav.dart';

enum NormalUserNavTab { home, map, foodOrdering, ticket, profile }

// final List<Widget> screens = [
//   HomeScreen(),
//   Placeholder(), // MAP
//   OrderScreen(),
//   Placeholder(), // TICKET
//   Account(),
// ];

class NormalUserApp extends StatefulWidget {
  const NormalUserApp({super.key});

  @override
  State<NormalUserApp> createState() => _NormalUserAppState();
}

class _NormalUserAppState extends State<NormalUserApp> {
  NormalUserNavTab selectedTab = NormalUserNavTab.home;
  bool _hasSeenFoodInstruction = false;

  Future<void> onTabSelected(NormalUserNavTab tab) async {
    Customer? user = context.read<UserProvider>().asCustomer;
    if (tab != NormalUserNavTab.ticket &&
        tab != NormalUserNavTab.foodOrdering) {
      setState(() {
        selectedTab = tab;
      });
    } else if (tab == NormalUserNavTab.ticket) {
      if (user != null && user.currentHistory != null) {
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
    } else if (tab == NormalUserNavTab.foodOrdering) {
      if (user != null && user.currentHistory != null) {
        if (!_hasSeenFoodInstruction) {
          setState(() {
            selectedTab = NormalUserNavTab.foodOrdering;
            _hasSeenFoodInstruction = true; // only once
          });
        } else {
          // Already seen instruction, go directly to menu screen
          context.go("/menu");
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: "Oops, A problem!",
              content: Column(
                children: [
                  Text(
                    "Please make sure you have checked in to the restaurant, so you can see start ordering.",
                    textAlign: TextAlign.center,
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
    final List<Widget> screens = [
      HomeScreen(),
      Placeholder(), // MAP
      _hasSeenFoodInstruction
          ? MenuScreen() // Already seen instruction, show menu
          : Instruction(
              onContinue: () {
                setState(() => _hasSeenFoodInstruction = true);
              },
            ),
      Placeholder(), // TICKET
      Account(),
    ];
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
