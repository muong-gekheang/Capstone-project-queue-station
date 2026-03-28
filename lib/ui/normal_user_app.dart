import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/services/queue_validateion_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/menu/menu_screen.dart';
import 'package:queue_station_app/ui/widgets/norml_user_buttom_nav.dart';

enum NormalUserNavTab { home, map, foodOrdering, ticket, profile }

class NormalUserApp extends StatefulWidget {
  const NormalUserApp({super.key});

  @override
  State<NormalUserApp> createState() => _NormalUserAppState();
}

class _NormalUserAppState extends State<NormalUserApp> {
  NormalUserNavTab selectedTab = NormalUserNavTab.home;
  bool _hasSeenFoodInstruction = false;
  bool _isNavigating = false;

  Future<void> onTabSelected(NormalUserNavTab tab) async {
    if (_isNavigating) return;

    final userProvider = context.read<UserProvider>();
    final customer = userProvider.asCustomer;

    // Handle non-queue tabs
    if (tab != NormalUserNavTab.ticket &&
        tab != NormalUserNavTab.foodOrdering) {
      setState(() => selectedTab = tab);
      return;
    }

    _isNavigating = true;

    try {
      bool canAccess = false;

      if (tab == NormalUserNavTab.ticket) {
        canAccess = await QueueValidationService.validateTicketAccess(
          context: context,
          customer: customer,
        );

        if (canAccess && context.mounted) {
          context.go("/ticket");
        }
      } else if (tab == NormalUserNavTab.foodOrdering) {
        final queueRepo = context.read<QueueEntryRepository>();

        canAccess = await QueueValidationService.validateMenuAccess(
          context: context,
          userProvider: userProvider,
          queueRepo: queueRepo,
          customer: customer,
          showLoading: true,
        );

        if (canAccess && context.mounted) {
          setState(() {
            selectedTab = NormalUserNavTab.foodOrdering;
            _hasSeenFoodInstruction = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Error in tab navigation: $e");
      if (context.mounted) {
        _showErrorDialog(
          context,
          'Error',
          'Something went wrong. Please try again.',
        );
      }
    } finally {
      _isNavigating = false;
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
      const HomeScreen(),
      const Placeholder(), // MAP
      const MenuScreen(),
      const Placeholder(), // TICKET
      const Account(),
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
