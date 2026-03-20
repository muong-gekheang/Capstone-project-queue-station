import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/menu_screen.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
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

  // Queue status constants
  static const String QUEUE_STATUS_WAITING = 'waiting';
  static const String QUEUE_STATUS_SERVING = 'serving';

  Future<void> onTabSelected(NormalUserNavTab tab) async {
    // Prevent multiple rapid taps
    if (_isNavigating) return;

    Customer? user = context.read<UserProvider>().asCustomer;

    // Handle non-queue tabs (home, map, profile)
    if (tab != NormalUserNavTab.ticket &&
        tab != NormalUserNavTab.foodOrdering) {
      setState(() {
        selectedTab = tab;
      });
      return;
    }

    // Handle ticket tab
    if (tab == NormalUserNavTab.ticket) {
      await _handleTicketTab(user);
      return;
    }

    // Handle food ordering/menu tab
    if (tab == NormalUserNavTab.foodOrdering) {
      await _handleFoodOrderingTab(user);
      return;
    }
  }

  Future<void> _handleTicketTab(Customer? user) async {
    if (user != null && user.currentHistoryId != null) {
      context.go("/ticket");
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: "No Queue Found",
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please make sure to join a queue first, so you can see your ticket.",
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

  Future<void> _handleFoodOrderingTab(Customer? user) async {
    _isNavigating = true;

    try {
      // Case 1: No user logged in
      if (user == null) {
        await _showQueueErrorDialog(
          'No Queue!',
          'We could not find your joined queue at the moment. Please make sure you have joined a queue and checked in.',
        );
        return;
      }

      // Case 2: customer.currentHistoryId is null (not yet joined queue)
      if (user.currentHistoryId == null) {
        await _showQueueErrorDialog(
          'No Queue!',
          'We could not find your joined queue at the moment. Please make sure you have joined a queue and checked in.',
        );
        return;
      }

      // Show loading indicator while checking queue status
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6835)),
          );
        },
      );

      // Get queue entry repository
      final queueRepo = context.read<QueueEntryRepository>();

      // Fetch the latest queue entry
      final queueEntry = await queueRepo.getQueueEntryById(
        user.currentHistoryId!,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      // Case 3: Queue entry not found
      if (queueEntry == null) {
        if (context.mounted) {
          await _showQueueErrorDialog(
            'Queue Error',
            'We could not find your queue entry. Please try again.',
          );
        }
        return;
      }

      final status = queueEntry.status.name.trim().toLowerCase();

      // Case 4: Joined (waiting) but not yet checked in
      if (status == QUEUE_STATUS_WAITING) {
        final queueNumber = queueEntry.queueNumber?.toString() ?? 'N/A';
        if (context.mounted) {
          await _showQueueErrorDialog(
            'Still in Queue!',
            'You have not checked in yet. Please make sure to check in when it is your turn.\n\nYour current queue: $queueNumber',
          );
        }
        return;
      }

      // Case 5: Success - user can access menu
      if (status == QUEUE_STATUS_SERVING) {
        if (!_hasSeenFoodInstruction) {
          // First time: show instruction and switch to food ordering tab
          setState(() {
            selectedTab = NormalUserNavTab.foodOrdering;
            _hasSeenFoodInstruction = true;
          });
        } else {
          // Already seen instruction, go directly to menu screen
          if (context.mounted) {
            context.go("/menu");
          }
        }
      } else {
        // Case 6: Other statuses (completed, cancelled, etc.)
        if (context.mounted) {
          await _showQueueErrorDialog(
            'Queue Status',
            'You cannot access the menu at this time. Queue status: ${queueEntry.status.name}',
          );
        }
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error checking queue: $e");
      if (context.mounted) {
        // Close loading dialog if it's still showing
        try {
          Navigator.of(context).pop();
        } catch (_) {}

        await _showQueueErrorDialog(
          'Error',
          'An error occurred while checking your queue status. Please try again.',
        );
      }
    } finally {
      _isNavigating = false;
    }
  }

  Future<void> _showQueueErrorDialog(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Stay on current tab (don't switch to menu)
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF6835),
              ),
              child: const Text('RETURN'),
            ),
          ],
        );
      },
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
