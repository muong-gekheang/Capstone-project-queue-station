import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/view_model/queue_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';
import 'package:queue_station_app/ui/widgets/guests_counter_widget.dart';

class EditQueueDialog extends StatefulWidget {
  final QueueEntry item;
  final VoidCallback onUpdate;
  final VoidCallback onRemove;
  const EditQueueDialog({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<EditQueueDialog> createState() => _EditQueueDialogState();
}

class _EditQueueDialogState extends State<EditQueueDialog> {
  late int _guestCount;

  @override
  void initState() {
    super.initState();
    _guestCount = widget.item.partySize;
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                Text(
                  "QN: ${widget.item.queueNumber}",
                  style: const TextStyle(
                    color: Color(0xFFFF6835),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Information:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            _infoLine("Email address:", widget.item.customerId),
            _infoLine("Customer name:", widget.item.customerId),
            _infoLine("Phone number:", widget.item.customerId),
            _infoLine(
              "Queued date:",
              DateFormat("dd/MMM/yyyy | hh:mm").format(widget.item.joinTime),
            ),

            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Table type:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
                          onTap: null,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 2,
                          onTap: null,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 3,
                          onTap: null,
                        ),
                        TableTypeWidget(
                          selectedType: _guestCount,
                          value: 4,
                          onTap: null,
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
                            onTap: null,
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
              incrPeople: null,
              decrPeople: null,
            ),

            const SizedBox(height: 35),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onUpdate();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6835),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Check in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "Remove "),
              TextSpan(
                text: "\"${widget.item.queueNumber}\"",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: " from the queue."),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      "No, Don't",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onRemove();
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Yes, Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            l,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              v,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    ),
  );
}
