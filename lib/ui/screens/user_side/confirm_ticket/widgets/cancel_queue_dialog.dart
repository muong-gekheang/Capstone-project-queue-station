// import 'package:flutter/material.dart';
// import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/view_models/confirm_ticket_view_model.dart';
// import 'package:queue_station_app/ui/theme/app_theme.dart';

// class CancelQueueDialog extends StatefulWidget {
//   final ConfirmTicketViewModel viewModel;

//   const CancelQueueDialog({super.key, required this.viewModel});

//   @override
//   State<CancelQueueDialog> createState() => _CancelQueueDialogState();
// }

// class _CancelQueueDialogState extends State<CancelQueueDialog> {
//   CancelReasonType? reason;

//   void onCancelTap() async {
//     widget.viewModel.setCancelReason(reason);

//     await widget.viewModel.cancelQueue();

//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Do you really want to cancel?",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.error,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...CancelReasonType.values.map(
//               (value) => ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 visualDensity: VisualDensity.compact,
//                 title: Text(_reasonText(value)),
//                 leading: Radio<CancelReasonType>(
//                   value: value,
//                   groupValue: reason,
//                   onChanged: (val) => setState(() => reason = val),
//                 ),
//                 onTap: () => setState(() => reason = value),
//               ),
//             ),
//             TextField(
//               onTap: () => setState(() => reason = CancelReasonType.other),
//               onChanged: (text) => widget.viewModel.setOtherReason(text),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(7),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 hintText: "Enter reason...",
//               ),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FilledButton(
//                   style: FilledButton.styleFrom(
//                     backgroundColor: AppTheme.naturalGrey,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     "No, Don't",
//                     style: TextStyle(color: AppTheme.naturalTextGrey),
//                   ),
//                 ),
//                 FilledButton(
//                   style: FilledButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.error,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                   ),
//                   onPressed: onCancelTap,
//                   child: const Text("Yes, Cancel"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _reasonText(CancelReasonType type) {
//     switch (type) {
//       case CancelReasonType.tooLong:
//         return "Queue is too long";
//       case CancelReasonType.changePlan:
//         return "Change of plan";
//       case CancelReasonType.other:
//         return "Other";
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/view_models/confirm_ticket_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class CancelQueueDialog extends StatefulWidget {
  final ConfirmTicketViewModel viewModel;

  const CancelQueueDialog({super.key, required this.viewModel});

  @override
  State<CancelQueueDialog> createState() => _CancelQueueDialogState();
}

class _CancelQueueDialogState extends State<CancelQueueDialog> {
  CancelReasonType? reason;
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void onCancelTap() async {
    if (reason == null) {
      // Show snackbar or toast asking to select a reason
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for cancellation'),
        ),
      );
      return;
    }

    // Set the reason first
    widget.viewModel.setCancelReason(reason);

    // If it's "other", set the other reason text
    if (reason == CancelReasonType.other) {
      widget.viewModel.setOtherReason(_otherReasonController.text);
    }

    print('===== CANCEL QUEUE DEBUG =====');
    print('Reason selected: $reason');
    print('Other reason text: ${_otherReasonController.text}');

    // Perform cancellation
    final success = await widget.viewModel.cancelQueue();

    print('Cancellation success: $success');

    if (mounted) {
      Navigator.pop(context, success);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Queue cancelled successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Do you really want to cancel?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...CancelReasonType.values.map(
              (value) => ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text(_reasonText(value)),
                leading: Radio<CancelReasonType>(
                  value: value,
                  groupValue: reason,
                  onChanged: (val) => setState(() {
                    reason = val;
                    if (val != CancelReasonType.other) {
                      _otherReasonController.clear();
                    }
                  }),
                ),
                onTap: () => setState(() {
                  reason = value;
                  if (value != CancelReasonType.other) {
                    _otherReasonController.clear();
                  }
                }),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _otherReasonController,
              onTap: () => setState(() {
                reason = CancelReasonType.other;
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: "Enter reason...",
                enabled: reason == CancelReasonType.other,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.naturalGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "No, Don't",
                    style: TextStyle(color: AppTheme.naturalTextGrey),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: onCancelTap,
                  child: const Text("Yes, Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _reasonText(CancelReasonType type) {
    switch (type) {
      case CancelReasonType.tooLong:
        return "Queue is too long";
      case CancelReasonType.changePlan:
        return "Change of plan";
      case CancelReasonType.other:
        return "Other";
    }
  }
}
