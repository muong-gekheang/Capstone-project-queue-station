import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/restaurant_service.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/view_model/queue_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/widgets/queue_content.dart';

class StoreQueueScreen extends StatelessWidget {
  final VoidCallback? onClose; // This is used to back to the parent screen
  const StoreQueueScreen({super.key, this.onClose});
  @override
  Widget build(BuildContext context) {
    RestaurantService restaurantService = context.read<RestaurantService>();
    return ChangeNotifierProvider(
      create: (_) => QueueViewModel(restaurantService: restaurantService),
      child: QueueContent(),
    );
  }
}
