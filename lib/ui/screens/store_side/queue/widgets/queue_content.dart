import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/view_model/queue_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/widgets/add_queue_dialog.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/widgets/edit_queue_dialog.dart';
import 'package:queue_station_app/ui/widgets/search_box.dart';

class QueueContent extends StatefulWidget {
  final VoidCallback? onClose; // This is used to back to the parent screen
  const QueueContent({super.key, this.onClose});
  @override
  State<QueueContent> createState() => _QueueContentState();
}

class _QueueContentState extends State<QueueContent> {
  @override
  Widget build(BuildContext context) {
    QueueViewModel queueViewModel = context.watch<QueueViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: const Icon(
          Icons.dashboard,
          color: Color(0xFF0D47A1),
          size: 32,
        ),
        title: const Text(
          "Queue",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "DORI\nDORI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: Colors.black, size: 30),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBox(onSearch: queueViewModel.onSearch),
          ),
          Expanded(
            child: queueViewModel.filteredQueue.isEmpty
                ? Text("No Queue yet")
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 100),
                    itemCount: queueViewModel.filteredQueue.length,
                    itemBuilder: (context, index) =>
                        _queueCard(queueViewModel.filteredQueue[index]),
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
            builder: (ctx) => ChangeNotifierProvider.value(
              value: queueViewModel,
              child: AddQueueDialog(onJoin: queueViewModel.addQueue),
            ),
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
    );
  }

  Widget _queueCard(QueueEntry item) {
    QueueViewModel queueViewModel = context.read<QueueViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              DateFormat(
                "hh:mm",
              ).format(queueViewModel.getQueueEstimatedTime(item)),
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
                builder: (ctx) => ChangeNotifierProvider.value(
                  value: queueViewModel,
                  child: EditQueueDialog(
                    item: item,
                    onUpdate: () => queueViewModel.serveQueue(item),
                    onRemove: () => queueViewModel.removeQueue(item),
                  ),
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
                          "${item.joinedMethod != JoinedMethod.remote ? item.customerName : item.customerId.substring(0, 4)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _cardLine(
                      "QN: ${item.queueNumber}",
                      "In-queue since: ${DateFormat.Hm().format(item.joinTime)}",
                    ),
                    const SizedBox(height: 4),
                    _cardLine(
                      "Guest(s): ${item.partySize}",
                      "Time waited: ${item.waitingTimeText}",
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
