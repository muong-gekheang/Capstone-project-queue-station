import 'package:flutter/material.dart';
import 'package:queue_station/ui/app_theme.dart';

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

  int _nextQn = 128;

  Widget _queueItem(String time, String name, String qn, String guests, String wait, String since) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('QN: $qn'),
                Text('In-queue since: $since', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people_alt, size: 16, color: AppTheme.primaryColor),
                    const SizedBox(width: 6),
                    Text('Guests: $guests', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Time waited', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(wait, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  void _showAddQueueBottomSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    int selectedTable = 2;
    int guests = 2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Queue',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Customer name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Table type:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [1, 2, 3, 4].map((p) {
                      bool isSelected = selectedTable == p;
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedTable = p),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor.withOpacity(0.15) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.transparent),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.event_seat, color: isSelected ? AppTheme.primaryColor : Colors.grey, size: 28),
                              Text('$p', style: TextStyle(color: isSelected ? AppTheme.primaryColor : Colors.black54)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Number of guests:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: AppTheme.primaryColor, size: 32),
                        onPressed: () { if (guests > 1) setSheetState(() => guests--); },
                      ),
                      Container(
                        width: 80,
                        alignment: Alignment.center,
                        child: Text('$guests', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 32),
                        onPressed: () => setSheetState(() => guests++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isNotEmpty) {
                              setState(() {
                                _queues.insert(0, {
                                  'time': 'Now',
                                  'name': nameController.text.trim(),
                                  'qn': 'D0$_nextQn',
                                  'guests': '$guests',
                                  'wait': '0m',
                                  'since': 'Now',
                                });
                                _nextQn++;
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Join Queue', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _queues.map((q) => _queueItem(
                  q['time']!,
                  q['name']!,
                  q['qn']!,
                  q['guests']!,
                  q['wait']!,
                  q['since']!,
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