import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/widgets/ticket_widget.dart';

class TicketQueueInfo extends StatelessWidget {
  const TicketQueueInfo({
    super.key,
    required this.queueEntry,
    required this.restaurant,
    required this.queueEntriesCount,
    required this.customerPosition,
    required this.estimatedWaitTime, // Add estimated wait time
  });

  final QueueEntry queueEntry;
  final Restaurant restaurant;
  final int queueEntriesCount;
  final int customerPosition;
  final Duration estimatedWaitTime; // Use Duration from QueueService

  // Format the estimated wait time for display
  String get formattedEstimatedWaitTime {
    final minutes = estimatedWaitTime.inMinutes;

    if (minutes <= 0) {
      return "Calculating...";
    } else if (minutes < 60) {
      return "$minutes minute${minutes > 1 ? 's' : ''}";
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return "$hours hour${hours > 1 ? 's' : ''}";
      } else {
        return "$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min";
      }
    }
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
                child: SizedBox.square(
                  dimension: 160,
                  child: Image.network(
                    restaurant.logoLink,
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
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    Text(
                      restaurant.name,
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
                            restaurant.address,
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
                        '$customerPosition',
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
                "Estimated Waiting Time",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedEstimatedWaitTime,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (queueEntriesCount > 0)
                    Text(
                      "Based on average wait time",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "We reserve the right to skip the queue position in case of no show",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 253, 154, 154),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
