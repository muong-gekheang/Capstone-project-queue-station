import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/view_models/join_queue_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/full_width_filled_button.dart';

class JoinQueueContent extends StatelessWidget {
  const JoinQueueContent({super.key, required this.rest});

  final Restaurant rest;

  @override
  Widget build(BuildContext context) {

    final joinQueueVM = context.watch<JoinQueueViewModel>();

    return CustomScreenView(
      title: "Get Queue",
      isTitleCenter: true,
      content: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(3),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.25).toInt()),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    SizedBox.square(
                      dimension: 160,
                      child: rest.logoLink != null && rest.logoLink.isNotEmpty
                          ? Image.network(
                              rest.logoLink,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.restaurant,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.restaurant,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            rest.name,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFF6835),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              const Icon(Icons.location_pin),
                              Expanded(
                                child: Text(
                                  rest.address,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Color(0xFF0D47A1),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (rest.policy.isNotEmpty)
                  const Text(
                    "Restaurant Policy",
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                if (rest.policy.isNotEmpty)
                  Text(
                    rest.policy,
                    style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                  ),
                const Text(
                  "Our Biggest Table Size",
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${rest.biggestTableSize.toString()} people per table",
                  style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                ),
                const Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  joinQueueVM.formattedPhone(rest.phone),
                  style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Color(0xFFFF6835),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            title: const Text(
              "Wait",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Estimated waiting time: ${rest.averageWaitingTime.inMinutes} min",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  joinQueueVM.queueCount.toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Entries",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (joinQueueVM.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                joinQueueVM.errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            "Queue Type",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final value = index + 1;
              return TableTypeWidget(
                selectedType: joinQueueVM.numPeople,
                value: value,
                onTap: joinQueueVM.setNumPeople,
              );
            }),
              
          ),
          const SizedBox(height: 16),
          const Text("Number of Guest(s)", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 19,
            children: [
              IconButton(
                onPressed: joinQueueVM.numPeople == 0 ? null : joinQueueVM.decrPeople,
                color: Colors.white,
                disabledColor: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFFFF6835),
                  disabledBackgroundColor: Color(0xFFD4D8D6),
                ),
                icon: const Icon(Icons.remove),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF73706E), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      NumberFormat("00").format(joinQueueVM.numPeople),
                      style: TextStyle(
                        letterSpacing: 10,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                        height: 1.0,
                      ),
                    ),
                    const Positioned.fill(
                      child: VerticalDivider(
                        color: Color(0xFF73706E),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => joinQueueVM.incrPeople(rest.biggestTableSize),
                color: Colors.white,
                style: IconButton.styleFrom(backgroundColor: Color(0xFFFF6835)),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: FullWidthFilledButton(
        onPress:
            (joinQueueVM.numPeople > 0 &&
                !joinQueueVM.isLoading &&
                joinQueueVM.userProvider.asCustomer?.currentHistoryId == null)
            ? () async {
                // Call joinQueue and wait for the result
                final createdEntry = await joinQueueVM.joinQueue(rest.id);

                // Check if context is still mounted and entry was created
                if (context.mounted && createdEntry != null) {
                  // Navigate to ticket screen with the queue entry data
                  context.go(
                    "/ticket",
                    extra: {'queueEntry': createdEntry, 'restaurant': rest},
                  );
                }
                // If createdEntry is null, error message will be shown in UI
              }
            : null,
        label: joinQueueVM.userProvider.asCustomer?.currentHistoryId != null
            ? "Already in Queue"
            : (joinQueueVM.isLoading ? "Processing..." : "Join Queue"),
      ),
    );
  }
}
