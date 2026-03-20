import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/view_models/confirm_ticket_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/cancel_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/ticket_queue_info.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/full_width_filled_button.dart';

class ConfirmTicketContent extends StatelessWidget {
  final String queueEntryId;

  const ConfirmTicketContent({super.key, required this.queueEntryId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfirmTicketViewModel>();

    // Load ticket if not loaded yet
    if (!vm.loading && vm.ticket == null && vm.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.loadTicket(queueEntryId);
      });
    }

    if (vm.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.error != null) {
      return Scaffold(body: Center(child: Text(vm.error!)));
    }

    if (vm.ticket == null || vm.restaurant == null) {
      return const Scaffold(body: Center(child: Text("Ticket not found.")));
    }

    // Check if queue status is waiting
    final bool isWaiting = vm.ticket!.status == QueueStatus.waiting;

    return CustomScreenView(
      title: "Queue Information",
      isTitleCenter: true,
      automaticImplyLeading: true,
      content: Column(
        spacing: 20,
        children: [
          TicketQueueInfo(queueEntry: vm.ticket!, restaurant: vm.restaurant!),
          if (isWaiting)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => CancelQueueDialog(viewModel: vm),
              ),
              child: const Text(
                "Cancel Queue",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
        ],
      ),
      bottomNavigationBar: FullWidthFilledButton(
        label: "Back to Home",
        onPress: () => context.go("/"),
      ),
    );
  }
}
