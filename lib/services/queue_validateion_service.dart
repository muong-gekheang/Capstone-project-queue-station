import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class QueueValidationService {
  static const String STATUS_WAITING = 'waiting';
  static const String STATUS_SERVING = 'serving';

  /// Validate queue access and show appropriate dialogs
  /// Returns true if user can access the feature
  static Future<bool> validateAndShowDialog({
    required BuildContext context,
    required UserProvider userProvider,
    required QueueEntry? currentQueueEntry,
    required Future<void> Function() refreshQueueStatus,
    String feature = 'menu', // 'menu', 'ticket', etc.
  }) async {
    // Check if user is logged in
    final customer = userProvider.asCustomer;
    if (customer == null) {
      _showErrorDialog(
        context,
        'No user logged in',
        'Please log in to access the ${feature == 'menu' ? 'menu' : 'ticket'}.',
      );
      return false;
    }

    // Refresh queue status to get latest
    await refreshQueueStatus();

    // Case 1: customer.currentHistoryId is null (not yet joined queue)
    if (customer.currentHistoryId == null) {
      _showErrorDialog(
        context,
        'No Queue!',
        'We could not find your joined queue at the moment. Please make sure you have joined a queue and checked in.',
      );
      return false;
    }

    // Case 2: joined (waiting) and not yet checked in
    if (currentQueueEntry != null) {
      final status = _normalizeStatus(currentQueueEntry.status.name);
      final queueNumber = currentQueueEntry.queueNumber?.toString() ?? 'N/A';

      if (status == STATUS_WAITING) {
        _showWaitingDialog(context, queueNumber: queueNumber, feature: feature);
        return false;
      }

      // Case 3: other invalid statuses
      if (status != STATUS_SERVING) {
        _showErrorDialog(
          context,
          'Cannot Access ${feature == 'menu' ? 'Menu' : 'Ticket'}',
          'You cannot access the ${feature == 'menu' ? 'menu' : 'ticket'} at this time.\n\nQueue status: ${currentQueueEntry.status.name}',
        );
        return false;
      }
    }

    return true;
  }

  /// Simplified validation for ticket access
  static Future<bool> validateTicketAccess({
    required BuildContext context,
    required Customer? customer,
  }) async {
    if (customer == null) {
      _showErrorDialog(
        context,
        'No user logged in',
        'Please log in to access your ticket.',
      );
      return false;
    }

    if (customer.currentHistoryId == null) {
      _showErrorDialog(
        context,
        'No queue found',
        'We could not find your joined queue at the moment. Please make sure to join a queue first so you can see your ticket.',
      );
      return false;
    }

    return true;
  }

  /// Validate menu access with loading state
  static Future<bool> validateMenuAccess({
    required BuildContext context,
    required UserProvider userProvider,
    required QueueEntryRepository queueRepo,
    required Customer? customer,
    bool showLoading = true,
  }) async {
    if (customer == null) {
      _showErrorDialog(
        context,
        'No user logged in',
        'Please log in to access the menu.',
      );
      return false;
    }

    if (customer.currentHistoryId == null) {
      _showErrorDialog(
        context,
        'No queue found',
        'We could not find your joined queue at the moment. Please make sure you have joined a queue and checked in.',
      );
      return false;
    }

    if (showLoading) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6835)),
          );
        },
      );
    }

    try {
      final queueEntry = await queueRepo.getQueueEntryById(
        customer.currentHistoryId!,
      );

      if (showLoading && context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (queueEntry == null) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Queue error',
            'We could not find your queue entry. Please try again.',
          );
        }
        return false;
      }

      final status = _normalizeStatus(queueEntry.status.name);
      final queueNumber = queueEntry.queueNumber?.toString() ?? 'N/A';

      if (status == STATUS_WAITING) {
        if (context.mounted) {
          _showWaitingDialog(
            context,
            queueNumber: queueNumber,
            feature: 'menu',
          );
        }
        return false;
      }

      if (status != STATUS_SERVING) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Cannot access menu',
            'You cannot access the menu at this time.\n\nQueue status: ${queueEntry.status.name}',
          );
        }
        return false;
      }

      return true;
    } catch (e) {
      if (showLoading && context.mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
      }

      if (context.mounted) {
        _showErrorDialog(
          context,
          'Something went wrong',
          'An error occurred while checking your queue status. Please try again.',
        );
      }
      return false;
    }
  }

  static String _normalizeStatus(String status) => status.trim().toLowerCase();

  static void _showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text.rich(
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB22222),
              ),
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF6835),
              ),
              child: const Text(
                'RETURN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showWaitingDialog(BuildContext context, {
    required String queueNumber,
    required String feature,
  }) {
    showDialog(
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
                  'Still in Queue!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB22222),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have not checked in yet. Please make sure to check in when it is your turn to access the ${feature == 'menu' ? 'menu' : 'ticket'}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.6,
                  ),
                ),
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
                const SizedBox(height: 24),
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
