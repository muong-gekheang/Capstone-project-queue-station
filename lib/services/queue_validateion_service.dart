// lib/services/queue_validation_service.dart
import 'package:flutter/material.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class QueueValidationService {
  static Future<bool> validateAndShowDialog({
    required BuildContext context,
    required UserProvider userProvider,
    required QueueEntry? currentQueueEntry,
    required Future<void> Function() refreshQueueStatus,
  }) async {
    // Check if user is logged in
    final customer = userProvider.asCustomer;
    if (customer == null) {
      _showErrorDialog(
        context,
        'No user logged in',
        'Please log in to access the menu.',
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

      if (status == 'waiting') {
        final queueNumber = currentQueueEntry.queueNumber.toString() ?? 'N/A';
        _showErrorDialog(
          context,
          'Still in Queue!',
          'You have not checked in yet. Please make sure to check in when it is your turn.\n\nYour current queue: $queueNumber',
        );
        return false;
      }

      // Case 3: other invalid statuses
      if (status != 'serving') {
        _showErrorDialog(
          context,
          'Queue Status',
          'You cannot access the menu at this time. Queue status: ${currentQueueEntry.status.name}',
        );
        return false;
      }
    }

    return true;
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
                color: Color(0xFFB22222), // red
              ),
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF6835),
              ),
              child: const Text('RETURN', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }
}
