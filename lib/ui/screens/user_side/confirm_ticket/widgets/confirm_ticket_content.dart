import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/view_models/confirm_ticket_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/cancel_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/ticket_queue_info.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/full_width_filled_button.dart';

class ConfirmTicketContent extends StatefulWidget {
  final String queueEntryId;

  const ConfirmTicketContent({super.key, required this.queueEntryId});

  @override
  State<ConfirmTicketContent> createState() => _ConfirmTicketContentState();
}

class _ConfirmTicketContentState extends State<ConfirmTicketContent> {
  Duration _estimatedWaitTime = Duration.zero;
  bool _isLoadingWaitTime = true;

  @override
  void initState() {
    super.initState();
    _loadEstimatedWaitTime();
  }

  Future<void> _loadEstimatedWaitTime() async {
    final vm = context.read<ConfirmTicketViewModel>();

    // Wait for ticket to load first
    if (vm.ticket != null) {
      final waitTime = await vm.getEstimatedWaitTime();
      if (mounted) {
        setState(() {
          _estimatedWaitTime = waitTime;
          _isLoadingWaitTime = false;
        });
      }
    } else {
      // If ticket not loaded yet, wait a bit and try again
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _loadEstimatedWaitTime();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfirmTicketViewModel>();

    // Load ticket if not loaded yet
    if (!vm.loading && vm.ticket == null && vm.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.loadTicket(widget.queueEntryId);
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

    final bool isWaiting = vm.ticket!.status == QueueStatus.waiting;

    return CustomScreenView(
      title: "Queue Information",
      isTitleCenter: true,
      automaticImplyLeading: true,
      content: Column(
        spacing: 20,
        children: [
          TicketQueueInfo(
            queueEntry: vm.ticket!,
            restaurant: vm.restaurant!,
            queueEntriesCount: vm.currentQueueEntriesCount,
            customerPosition: vm.customerPosition,
            estimatedWaitTime: _isLoadingWaitTime
                ? Duration.zero
                : _estimatedWaitTime,
          ),
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
          if (!isWaiting)
            FilledButton(
              onPressed: () async {
                final result = await vm.leaveStore();
                if (result && context.mounted) Navigator.pop(context);
                debugPrint("Leave store tap");
              },
              child: Text("Leave Store"),
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
