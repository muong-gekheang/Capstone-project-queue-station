import 'package:flutter/material.dart';

class ManageQueueScreen extends StatefulWidget {
  const ManageQueueScreen({super.key});

  @override
  State<ManageQueueScreen> createState() => _ManageQueueScreenState();
}

class _ManageQueueScreenState extends State<ManageQueueScreen> {
  // Sample queue data (static for now)
  List<Map<String, String>> _queues = [
    {"name": "Queue 1", "status": "Waiting"},
    {"name": "Queue 2", "status": "Serving"},
    {"name": "Queue 3", "status": "Done"},
  ];

  void _addQueue() {
    setState(() {
      int nextNumber = _queues.length + 1;
      _queues.add({"name": "Queue $nextNumber", "status": "Waiting"});
    });
  }

  void _nextQueue(int index) {
    setState(() {
      if (_queues[index]["status"] == "Waiting") {
        _queues[index]["status"] = "Serving";
      } else if (_queues[index]["status"] == "Serving") {
        _queues[index]["status"] = "Done";
      }
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Waiting":
        return Colors.orange;
      case "Serving":
        return Colors.blue;
      case "Done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Manage Queue"),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _queues.length,
                itemBuilder: (context, index) {
                  final queue = _queues[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(queue["name"]!),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(queue["status"]!).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          queue["status"]!,
                          style: TextStyle(
                            color: _statusColor(queue["status"]!),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () => _nextQueue(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _addQueue,
                icon: const Icon(Icons.add),
                label: const Text("Add Queue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
