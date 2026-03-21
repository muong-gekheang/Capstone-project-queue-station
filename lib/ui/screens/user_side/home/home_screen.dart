import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/customer_repository_impl.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/home/view_models/home_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/home/widgets/home_content.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        restaurantRepository: context.read<RestaurantRepository>(), 
        orderRepository: context.read<OrderRepository>(),
        userProvider: context.read<UserProvider>(),
        queueEntryRepository: context.read<QueueEntryRepository>(),
        customerRepositoryImpl: context.read<CustomerRepositoryImpl>()
      ),
      child: HomeContent(),
    );
  }
}

