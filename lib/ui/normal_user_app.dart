import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No queue found',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFFB22222),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Message
                  Text(
                    'We could not find your joined queue at the moment. Please make sure to join a queue first so you can see your ticket.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Return button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6835),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Return',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          title: 'No queue found',
          message:
              'We could not find your joined queue at the moment. Please make sure you have joined a queue and checked in.',
        );
        return;
      }

      // Case 2: customer.currentHistoryId is null (not yet joined queue)
      if (user.currentHistoryId == null) {
        await _showQueueErrorDialog(
          title: 'No queue found',
          message:
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
        Navigator.of(context).pop();
      }

      // Case 3: Queue entry not found
      if (queueEntry == null) {
        if (context.mounted) {
          await _showQueueErrorDialog(
            title: 'Queue error',
            message: 'We could not find your queue entry. Please try again.',
          );
        }
        return;
      }

      final status = queueEntry.status.name.trim().toLowerCase();

      // Case 4: Joined (waiting) but not yet checked in
      if (status == QUEUE_STATUS_WAITING) {
        final queueNumber = queueEntry.queueNumber.toString();
        if (context.mounted) {
          await _showQueueErrorDialog(
            title: 'Still in queue',
            message:
                'You have not checked in yet. Please make sure to check in when it is your turn.',
            queueNumber: queueNumber,
          );
        }
        return;
      }

      // Case 5: Success - user can access menu
      if (status == QUEUE_STATUS_SERVING) {
        if (!_hasSeenFoodInstruction) {
          setState(() {
            selectedTab = NormalUserNavTab.foodOrdering;
            _hasSeenFoodInstruction = true;
          });
        } else {
          if (context.mounted) {
            context.go("/menu");
          }
        }
      } else {
        // Case 6: Other statuses (completed, cancelled, etc.)
        if (context.mounted) {
          await _showQueueErrorDialog(
            title: 'Cannot access menu',
            message:
                'You cannot access the menu at this time. Queue status: ${queueEntry.status.name}',
          );
        }
      }
    } catch (e) {
      debugPrint("Error checking queue: $e");
      if (context.mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}

        await _showQueueErrorDialog(
          title: 'Something went wrong',
          message:
              'An error occurred while checking your queue status. Please try again.',
        );
      }
    } finally {
      _isNavigating = false;
    }
  }

  Future<void> _showQueueErrorDialog({
    required String title,
    required String message,
    String? queueNumber,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB22222),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.6,
                  ),
                ),

                // Queue number badge (only for "still waiting" case)
                if (queueNumber != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text( 
                          'Your queue number is:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF6835),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          queueNumber,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6835),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Return button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6835),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Return',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
