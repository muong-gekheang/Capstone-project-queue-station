import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart'; // for restaurant1
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class TicketQueueInfo extends StatelessWidget {
  const TicketQueueInfo({super.key, required this.queueEntry});

  final QueueEntry queueEntry;

  // Mock function – replace with actual logic
  int _getCurrentSpot() {
    // This is a placeholder. In a real app, you'd compute the spot from the queue.
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      topContent: Column(
        children: [
          Row(
            spacing: 13,
            children: [
              SizedBox.square(
                dimension: 70,
                child: Image.asset("assets/home_screen/kungfu.png"),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    Text(
                      restaurant1.name,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        Expanded(
                          child: Text(
                            restaurant1.address,
                            softWrap: true,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
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
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Queue Number",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        queueEntry.id.substring(0, 4),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: VerticalDivider(thickness: 2, color: Colors.white),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Wait Queue",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        _getCurrentSpot().toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomContent: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(
                Icons.date_range_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Text(
                DateFormat("dd / MMM/ yyyy").format(queueEntry.joinTime),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Joined queue time",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                DateFormat("h:mm:ss a").format(queueEntry.joinTime),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Number of Guest(s)",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                queueEntry.partySize.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Estimated Waiting time",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                "1h - 1:30h",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "We reserve the right to skip the queue position in case of no show",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 253, 154, 154),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
