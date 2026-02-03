import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/cancel_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/ticket_queue_info.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/join_queue_screen.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/full_width_filled_button.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class ConfirmTicketScreen extends StatefulWidget {
  const ConfirmTicketScreen({super.key, required this.widget});

  final JoinQueueScreen widget;

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
      content: Column(
        spacing: 20,
        children: [
          TicketQueueInfo(widget: widget),
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
          // TODO: Implement GO ROUTER
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
}
