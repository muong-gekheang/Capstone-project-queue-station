import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/model/history.dart';
import 'package:queue_station_app/ui/widgets/half_clipper.dart';

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key, required this.history});

  final History history;

  @override
  Widget build(BuildContext context) {
    String guestSuffix = history.guests > 1 ? "People" : "Person";

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        spacing: 20,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
            child: Column(
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
                            history.rest.name,
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
                                  history.rest.address,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
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
                SizedBox(height: 10),
                Text(
                  "Your Queue Number",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  history.queueId,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 0.5,
                child: ClipRect(
                  clipper: HalfClipper(Side.right),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Expanded(child: DottedLine(dashColor: Colors.white)),
              Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: ClipRect(
                  clipper: HalfClipper(Side.left),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
            child: Column(
              children: [
                Text(
                  "Status",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  history.status.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    Text(
                      DateFormat("dd / MMM/ yyyy").format(history.queueDate),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                      DateFormat("h:mm:ss a").format(history.queueDate),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                      "${history.guests.toString()} $guestSuffix",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
