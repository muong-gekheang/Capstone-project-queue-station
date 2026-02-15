import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/widgets/search_box.dart';
import '../dialogs/add_queue_dialog.dart';
import '../dialogs/edit_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';


class StoreQueueScreen extends StatefulWidget {
  const StoreQueueScreen({super.key});
  @override
  State<StoreQueueScreen> createState() => _StoreQueueScreenState();
}

class _StoreQueueScreenState extends State<StoreQueueScreen> {
  List<Map<String, dynamic>> allQueues = [
    {"time": "9:00 am", "name": "Mary Ann", "qn": "D0123", "guests": 4, "since": "7:00 pm", "waited": "2h 30mn", "email": "mary.ann@gmail.com", "phone": "011 22 44 56", "date": "10/Oct/2025 | 7:30:42 pm"},
    {"time": "9:30 am", "name": "John Doe", "qn": "D0124", "guests": 2, "since": "7:30 pm", "waited": "2h 0mn", "email": "john.doe@gmail.com", "phone": "012 11 33 55", "date": "10/Oct/2025 | 7:45:00 pm"},
  ];
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = allQueues;
  }

  void _runFilter(String query) {
    setState(() {
      filteredList = allQueues.where((q) =>
          q["name"].toLowerCase().contains(query.toLowerCase()) ||
          q["qn"].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _handleQueueUpdate(String qn) {
    setState(() {
      allQueues.removeWhere((item) => item['qn'] == qn);
      filteredList = List.from(allQueues);
    });
  }

  void _addToQueue(String name, String phone, int guests) {
    setState(() {
      allQueues.add({
        "time": "Now",
        "name": name.isEmpty ? "New Customer" : name,
        "qn": "D0${125 + allQueues.length}",
        "guests": guests,
        "since": "Just now",
        "waited": "0mn",
        "email": "-",
        "phone": phone,
        "date": "Today"
      });
      filteredList = List.from(allQueues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: const Icon(Icons.dashboard, color: Color(0xFF0D47A1), size: 32),
        title: const Text("Queue", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text("DORI\nDORI", 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold, height: 1.0)
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: Colors.black, size: 30),
          const SizedBox(width: 16)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBox(onSearch: _runFilter),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              itemCount: filteredList.length,
              itemBuilder: (context, index) => _queueCard(filteredList[index]),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
          ),
          onPressed: () => showDialog(
            context: context, 
            builder: (ctx) => AddQueueDialog(onJoin: _addToQueue)
          ),
          child: const Text("Add queue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard, color: Colors.black), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.store, color: Color(0xFFFF6835)), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.black), label: ""),
        ],
      ),
    );
  }

  Widget _queueCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(item['time'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => showDialog(
                context: context, 
                builder: (ctx) => EditQueueDialog(
                  item: item, 
                  onUpdate: () => _handleQueueUpdate(item['qn']),
                )
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black87, width: 1.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(children: [
                      const CircleAvatar(radius: 14, backgroundColor: Colors.orange), 
                      const SizedBox(width: 10), 
                      Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                    ]),
                    const SizedBox(height: 12),
                    _cardLine("QN: ${item['qn']}", "In-queue since: ${item['since']}"),
                    const SizedBox(height: 4),
                    _cardLine("Guest(s): ${item['guests']}", "Time waited: ${item['waited']}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardLine(String l, String r) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      Text(r, style: const TextStyle(fontSize: 10, color: Colors.black87))
    ],
  );
}
