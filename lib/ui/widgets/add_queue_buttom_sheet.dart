import 'package:flutter/material.dart';
import 'package:queue_station/ui/app_theme.dart';
import 'package:queue_station/widgets/queue_item_card.dart';
import 'package:queue_station/widgets/add_queue_bottom_sheet.dart';

class ManageQueueScreen extends StatefulWidget {
  const ManageQueueScreen({super.key});

  @override
  State<ManageQueueScreen> createState() => _ManageQueueScreenState();
}

class _ManageQueueScreenState extends State<ManageQueueScreen> {
  final List<Map<String, String>> _queues = [
    {'time': '9:00 am', 'name': 'Mary Ann', 'qn': 'D0123', 'guests': '4', 'wait': '2h 30m', 'since': '7:00 pm'},
    {'time': '9:30 am', 'name': 'John Doe', 'qn': 'D0124', 'guests': '2', 'wait': '2h', 'since': '7:30 pm'},
    {'time': '10:00 am', 'name': 'Jane Smith', 'qn': 'D0125', 'guests': '3', 'wait': '1h 30m', 'since': '8:00 pm'},
    {'time': '10:30 am', 'name': 'Robert Lee', 'qn': 'D0126', 'guests': '1', 'wait': '1h', 'since': '8:30 pm'},
    {'time': '11:00 am', 'name': 'Emily Davis', 'qn': 'D0127', 'guests': '5', 'wait': '30m', 'since': '9:00 pm'},
  ];

  void _addNewQueue(Map<String, String> newEntry) {
    setState(() {
      _queues.insert(0, newEntry);
    });
  }

  void _showAddQueueBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => AddQueueBottomSheet(onAdd: _addNewQueue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search customer name or queue ID',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _queues.map((q) => QueueItemCard(
                  time: q['time']!,
                  name: q['name']!,
                  qn: q['qn']!,
                  guests: q['guests']!,
                  wait: q['wait']!,
                  since: q['since']!,
                )).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _showAddQueueBottomSheet,
                child: const Text('Add queue'),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}