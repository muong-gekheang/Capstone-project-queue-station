import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/view_model/store_queue_history_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/widgets/store_queue_history_content.dart';

class StoreQueueHistoryScreen extends StatelessWidget {
  const StoreQueueHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreQueueHistoryViewModel(
        queueService: context.read<QueueService>(),
        orderService: context.read<OrderService>(),
      ),
      child: StoreQueueHistoryContent(),
    );
  }
}
