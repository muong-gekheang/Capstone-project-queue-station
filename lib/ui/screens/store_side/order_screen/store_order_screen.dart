import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/ui/screens/store_side/order_screen/view_model/store_order_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/order_screen/widget/store_order_content.dart';

class StoreOrderScreen extends StatelessWidget {
  final String queueEntryId;
  const StoreOrderScreen({super.key, required this.queueEntryId});
  @override
  Widget build(BuildContext context) {
    debugPrint("QueueID: $queueEntryId");
    return ChangeNotifierProvider(
      create: (_) => StoreOrderViewModel(
        queueService: context.read<QueueService>(),
        orderService: context.read<OrderService>(),
      ),
      child: StoreOrderContent(queueEntryId: queueEntryId),
    );
  }
}
