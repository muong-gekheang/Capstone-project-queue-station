import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/cart/view_model/cart_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/cart/widgets/cart_content.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartViewModel>(
      create: (_) => CartViewModel(
        orderProvider: context.read<OrderProvider>(),
        userProvider: context.read<UserProvider>(),
        queueEntryRepository: context.read<QueueEntryRepository>(),
        userRepository: context.read<UserRepository<Customer>>(),
      ),
      child: CartContent(),
    );
  }
}
