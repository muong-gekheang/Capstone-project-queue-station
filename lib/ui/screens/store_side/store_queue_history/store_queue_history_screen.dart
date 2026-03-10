import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/view_model/store_queue_history_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/widgets/store_queue_history_content.dart';

class StoreQueueHistoryScreen extends StatelessWidget {
  final Restaurant restaurant; // Added this to receive the restaurant
  const StoreQueueHistoryScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreQueueHistoryViewModel(),
      child: StoreQueueHistoryContent(restaurant: restaurant),
    );
  }
}
