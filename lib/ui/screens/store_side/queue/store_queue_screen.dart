import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/view_model/queue_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/widgets/queue_content.dart';

class StoreQueueScreen extends StatelessWidget {
  final VoidCallback? onClose; // This is used to back to the parent screen
  final bool isPushed; // Whether this screen was pushed via Navigator.push
  
  const StoreQueueScreen({
    super.key,
    this.onClose,
    this.isPushed = false,
  });
  @override
  Widget build(BuildContext context) {
    RestaurantService restaurantService = context.read<RestaurantService>();
    QueueService queueService = context.read<QueueService>();
    return ChangeNotifierProvider(
      create: (_) => QueueViewModel(
        restaurantService: restaurantService,
        queueService: queueService,
      ),
      child: QueueContent(
        showBackButton: isPushed,
        onClose: onClose,
      ),
    );
  }
}
