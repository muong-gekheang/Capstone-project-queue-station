import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';

import 'queue_table.dart';
import 'menu_item.dart';

class Restaurant {
  final String name;
  final String address;
  final String logoLink;
  final String policy;
  final int biggestTableSize;
  final String phone;
  final List<MenuItem> items;
  final List<QueueTable> tables;
  final List<AddOn> globalAddOns;
  final List<SizeOption> globalSizeOptions;
  final List<QueueEntry> currentInQueue = [];

  Restaurant({
    required this.name,
    required this.address,
    required this.logoLink,
    this.policy = "",
    required this.biggestTableSize,
    required this.phone,
    required this.items,
    required this.tables,
    required this.globalAddOns,
    required this.globalSizeOptions,
  });

  void enqueue(QueueEntry queue) {
    if (!currentInQueue.contains(queue)) {
      currentInQueue.add(queue);
    }
  }

  void dequeue(QueueEntry queue) {
    currentInQueue.remove(queue);
  }

  int getQueueSpot(QueueEntry queue) {
    return currentInQueue.indexOf(queue) + 1; // BC it counts from 0
  }

  Duration get averageWaitingTime => Duration(hours: 1);

  int get curWait => currentInQueue.length;

  @override
  bool operator ==(Object other) {
    return (other is Restaurant) &&
        (other.name == name &&
            other.address == address &&
            other.phone == phone);
  }

  @override
  int get hashCode => Object.hash(name, address, phone);
}
