import 'package:flutter/material.dart';
import '../../join_queue/widgets/table_type_widget.dart'; 

class AddQueueDialog extends StatefulWidget {
  final Function(String, String, int) onJoin;
  const AddQueueDialog({super.key, required this.onJoin});
  @override
  State<AddQueueDialog> createState() => _AddQueueDialogState();
}

class _AddQueueDialogState extends State<AddQueueDialog> {
  int _selectedTable = 2; 
  int _guestCount = 2;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Add Queue", style: TextStyle(color: Color(0xFFFF6835), fontSize: 26, fontWeight: FontWeight.bold))),
            const SizedBox(height: 25),
            const Text("Basic info:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _field("Customer name:", nameController),
            _field("Phone number:", phoneController),
            const SizedBox(height: 25),
            const Text("Table type:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(context), 
                  style: TextButton.styleFrom(backgroundColor: Colors.grey.shade200, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Cancel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6835), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  onPressed: () {
                    widget.onJoin(nameController.text, phoneController.text, _guestCount);
                    Navigator.pop(context);
                  },
                  child: const Text("Join Queue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87))),
      Expanded(child: SizedBox(height: 38, child: TextField(controller: controller, decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))))))
    ]),
  );
}
