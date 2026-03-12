import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/widgets/search_box.dart';
import '../dialogs/add_queue_dialog.dart';
import '../dialogs/edit_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import 'package:queue_station_app/services/store_profile_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../models/nav_tab.dart';

class StoreQueueScreen extends StatefulWidget {
  final bool isPushed;
  final VoidCallback? onClose;
  const StoreQueueScreen({super.key, this.isPushed = false, this.onClose});

  @override
  State<StoreQueueScreen> createState() => _StoreQueueScreenState();
}

class _StoreQueueScreenState extends State<StoreQueueScreen> {
  late final StoreProfileService _storeService;
  List<Map<String, dynamic>> allQueues = [
    {
      "time": "9:00 am",
      "name": "Mary Ann",
      "qn": "D0123",
      "guests": 4,
      "since": "7:00 pm",
      "waited": "2h 30mn",
      "email": "mary.ann@gmail.com",
      "phone": "011 22 44 56",
      "date": "10/Oct/2025 | 7:30:42 pm",
    },
    {
      "time": "9:30 am",
      "name": "John Doe",
      "qn": "D0124",
      "guests": 2,
      "since": "7:30 pm",
      "waited": "2h 0mn",
      "email": "john.doe@gmail.com",
      "phone": "012 11 33 55",
      "date": "10/Oct/2025 | 7:45:00 pm",
    },
  ];
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    _storeService = StoreProfileService();
    _storeService.addListener(_onProfileChanged);
    filteredList = allQueues;
  }

  @override
  void dispose() {
    _storeService.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  void _runFilter(String query) {
    setState(() {
      filteredList = allQueues
          .where(
            (q) =>
                q["name"].toLowerCase().contains(query.toLowerCase()) ||
                q["qn"].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
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
        "date": "Today",
      });
      filteredList = List.from(allQueues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isPushed,
      onPopInvoked: (didPop) {
        if (widget.isPushed && !didPop) {
          Navigator.pop(context, NavTab.queue);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          automaticallyImplyLeading: widget.isPushed,
          leading: widget.isPushed
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context, NavTab.queue);
                  },
                )
              : null,
          title: const Text(
            "Queue",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          actions: [
            _buildStoreProfileImage(),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(isPushed: false,),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
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
                itemBuilder: (context, index) =>
                    _queueCard(filteredList[index]),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AddQueueDialog(onJoin: _addToQueue),
            ),
            child: const Text(
              "Add queue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreProfileImage() {
    final storeName = _storeService.storeName;

    ImageProvider? imageProvider;
    if (kIsWeb) {
      final bytes = _storeService.storeProfileImageBytes;
      if (bytes != null) imageProvider = MemoryImage(bytes);
    } else {
      final file = _storeService.storeProfileImage;
      if (file != null) imageProvider = FileImage(file);
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFFF6835).withValues(alpha: 0.1),
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? Text(
                storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Color(0xFFFF6835),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              )
            : null,
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
            child: Text(
              item['time'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => EditQueueDialog(
                  item: item,
                  onUpdate: () => _handleQueueUpdate(item['qn']),
                ),
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
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _cardLine(
                      "QN: ${item['qn']}",
                      "In-queue since: ${item['since']}",
                    ),
                    const SizedBox(height: 4),
                    _cardLine(
                      "Guest(s): ${item['guests']}",
                      "Time waited: ${item['waited']}",
                    ),
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
      Text(r, style: const TextStyle(fontSize: 10, color: Colors.black87)),
    ],
  );
}
