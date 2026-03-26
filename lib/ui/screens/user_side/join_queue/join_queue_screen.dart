import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/view_models/join_queue_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/join_queue_content.dart';

class JoinQueueScreen extends StatelessWidget {
  final Restaurant rest;
  const JoinQueueScreen({super.key, required this.rest});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JoinQueueViewModel(
        queueRepository: context.read<QueueEntryRepository>(),
        userProvider: context.read<UserProvider>(),
        restaurantRepository: context.read<RestaurantRepository>(),
        customerRepository: context.read<CustomerRepositoryImpl>(),
        queueService: context.read<QueueService>()
      ),
      child: JoinQueueContent(rest: rest),
    );
  }
}
