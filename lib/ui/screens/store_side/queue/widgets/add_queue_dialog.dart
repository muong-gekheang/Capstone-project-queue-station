import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/view_model/queue_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/guests_counter_widget.dart';
import 'package:uuid/uuid.dart';

class AddQueueDialog extends StatefulWidget {
  final ValueChanged<QueueEntry> onJoin;

  const AddQueueDialog({super.key, required this.onJoin});
  @override
  State<AddQueueDialog> createState() => _AddQueueDialogState();
}

class _AddQueueDialogState extends State<AddQueueDialog> {
  int _guestCount = 1;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String? nullValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void incrPeople() {
    QueueViewModel queueViewModel = context.read<QueueViewModel>();
    setState(() {
      _guestCount = min(_guestCount + 1, queueViewModel.biggestTableSize);
    });
  }

  void decrPeople() {
    setState(() {
      _guestCount = max(_guestCount - 1, 0);
    });
  }

  void onTableTap(int value) {
    setState(() {
      _guestCount = value;
    });
  }

  void onJoinTap() async {
    if (_formKey.currentState!.validate()) {
      StoreUser user = context.read<UserProvider>().asStoreUser!;
      QueueViewModel vm = context.read<QueueViewModel>();
      try {
        widget.onJoin(
          QueueEntry.walkIn(
            expectedTableReadyAt: DateTime.now(),
            id: Uuid().v4(),
            queueNumber: "ABCDE",
            partySize: _guestCount,
            joinTime: DateTime.now(),
            status: QueueStatus.waiting,
            customerId: user.id,
            joinedMethod: JoinedMethod.walkIn,
            restId: vm.restId,
            customerName: nameController.text,
            phoneNumber: phoneController.text,
            assignedTableId: '',
          ),
        );
      } catch (err) {
        debugPrint("ERROR: $err");
        await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Add Queue Error",
            content: Text("$err"),
            actions: [],
          ),
        );
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    QueueViewModel queueViewModel = context.watch<QueueViewModel>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Add Queue",
                style: TextStyle(
                  color: Color(0xFFFF6835),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Basic info:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _field("Customer name:", nameController, nullValidator),
                  _field("Phone number:", phoneController, nullValidator),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Table type:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20,
                alignment: WrapAlignment.center,
                children: (queueViewModel.biggestTableSize >= 4)
                    ? [
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 1,
                          onTap: onTableTap,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 2,
                          onTap: onTableTap,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 3,
                          onTap: onTableTap,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 4,
                          onTap: onTableTap,
                        ),
                      ]
                    : [
                        for (
                          int i = 1;
                          i < queueViewModel.biggestTableSize;
                          i++
                        )
                          TableTypeWidget(
                            value: i,
                            selectedType: _guestCount,
                            onTap: onTableTap,
                          ),
                      ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Number of guests:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            GuestsCounterWidget(
              maxPeople: queueViewModel.biggestTableSize,
              numPeople: _guestCount,
              incrPeople: incrPeople,
              decrPeople: decrPeople,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    title: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: AppTheme.naturalGrey,
                    textColor: AppTheme.naturalBlack,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    borderRadius: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    title: "Join Queue",
                    onPressed: _guestCount > 0 ? onJoinTap : null,
                    backgroundColor: AppTheme.primaryColor,
                    textColor: AppTheme.naturalWhite,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    borderRadius: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}
