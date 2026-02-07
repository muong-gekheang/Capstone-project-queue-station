import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_station_app/models/user/history.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/cancel_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/ticket_queue_info.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/full_width_filled_button.dart';

class ConfirmTicketScreen extends StatefulWidget {
  const ConfirmTicketScreen({super.key, required this.history});

  final History history;

  @override
  State<ConfirmTicketScreen> createState() => _ConfirmTicketScreenState();
}

class _ConfirmTicketScreenState extends State<ConfirmTicketScreen> {
  Future<void> onCancelQueue() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CancelQueueDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenView(
      title: "Queue Information",
      isTitleCenter: true,
      automaticImplyLeading: true,
      content: Column(
        spacing: 20,
        children: [
          TicketQueueInfo(history: widget.history),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              onCancelQueue();
            },
            child: Text(
              "Cancel Queue",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FullWidthFilledButton(
        label: "Back to Home",
        onPress: () {
          context.go("/");
        },
      ),
    );
  }
}
