import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/cart/view_model/cart_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order/widgets/order_content.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartViewModel(
        orderProvider: context.read<OrderProvider>(), 
        userProvider: context.read<UserProvider>(), 
        queueEntryRepository: context.read<QueueEntryRepository>()
      ),
      child: OrderContent(),
    );
  }
}
