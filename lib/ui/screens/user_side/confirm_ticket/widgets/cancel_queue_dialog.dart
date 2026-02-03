import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/app_theme.dart';

enum CancelReasonType { tooLong, changePlan, other }

class CancelQueueDialog extends StatefulWidget {
  const CancelQueueDialog({super.key});

  @override
  State<CancelQueueDialog> createState() => _CancelQueueDialogState();
}

class _CancelQueueDialogState extends State<CancelQueueDialog> {
  CancelReasonType? reason;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: RadioGroup<CancelReasonType>(
        groupValue: reason,
        onChanged: (value) => setState(() {
          reason = value;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                "Do you really want to cancel?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                title: Text("Queue is too long"),
                onTap: () => setState(() {
                  reason = CancelReasonType.tooLong;
                }),
                leading: Radio(value: CancelReasonType.tooLong),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                title: Text("Change of plan"),
                onTap: () => setState(() {
                  reason = CancelReasonType.changePlan;
                }),
                leading: Radio(value: CancelReasonType.changePlan),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                title: Text("Other"),
                onTap: () => setState(() {
                  reason = CancelReasonType.other;
                }),
                leading: Radio(value: CancelReasonType.other),
              ),
              TextField(
                onTap: () => setState(() {
                  reason = CancelReasonType.other;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),

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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                    onPressed: () {
                      // TODO: Implement go-router in the future
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Yes, Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
