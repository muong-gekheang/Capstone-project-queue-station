import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';


class EditQueueDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onUpdate; 
  const EditQueueDialog({super.key, required this.item, required this.onUpdate});

  @override
  State<EditQueueDialog> createState() => _EditQueueDialogState();
}

class _EditQueueDialogState extends State<EditQueueDialog> {
  int _selectedTable = 1;
  late int _guestCount;

  @override
  void initState() {
    super.initState();
    _guestCount = widget.item['guests'];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(width: 32),
              Text("QN: ${widget.item['qn']}", style: const TextStyle(color: Color(0xFFFF6835), fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.black54))
            ]),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text("Information:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 15),
            _infoLine("Email address:", widget.item['email']),
            _infoLine("Customer name:", widget.item['name']),
            _infoLine("Phone number:", widget.item['phone']),
            _infoLine("Queued date:", widget.item['date']),
            
            const SizedBox(height: 25),
            const Align(alignment: Alignment.centerLeft, child: Text("Table type:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3, 4].map((i) => TableTypeWidget(
                value: i,
                selectedType: _selectedTable,
                onTap: (val) => setState(() => _selectedTable = val),
              )).toList(),
            ),

            const SizedBox(height: 30),
            const Center(child: Text("Number of guests:", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () => setState(() => _guestCount > 0 ? _guestCount-- : null), icon: const Icon(Icons.remove_circle, color: Colors.grey, size: 34)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black45), borderRadius: BorderRadius.circular(8)),
                  child: Text(_guestCount.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                IconButton(onPressed: () => setState(() => _guestCount++), icon: const Icon(Icons.add_circle, color: Color(0xFFFF6835), size: 34)),
              ],
            ),

            const SizedBox(height: 35),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: () => _confirm(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  child: const Text("Remove", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () {
                    widget.onUpdate(); 
                    Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6835), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  child: const Text("Check in", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                )),
              ],
            )
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
        title: const Center(child: Text("Are you sure?", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22))),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(style: const TextStyle(color: Colors.black, fontSize: 16), children: [
            const TextSpan(text: "Remove "),
            TextSpan(text: "\"${widget.item['qn']}\"", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const TextSpan(text: " from the queue."),
          ]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Row(children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No, Don't", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)))),
              Expanded(child: ElevatedButton(
                onPressed: () { 
                  widget.onUpdate(); 
                  Navigator.pop(ctx); 
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text("Yes, Remove", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              )),
            ]),
          )
        ],
      ),
    );
  }

  Widget _infoLine(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      SizedBox(width: 110, child: Text(l, style: const TextStyle(fontSize: 12, color: Colors.black54))),
      Expanded(child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: Text(v, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))
      ))
    ]),
  );
}
