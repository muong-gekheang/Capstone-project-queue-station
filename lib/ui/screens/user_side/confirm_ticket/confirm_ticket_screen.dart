import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/services/queue_service.dart';

import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/view_models/confirm_ticket_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/widgets/confirm_ticket_content.dart';

class ConfirmTicketScreen extends StatelessWidget {
  final String queueEntryId;

  const ConfirmTicketScreen({super.key, required this.queueEntryId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfirmTicketViewModel(
        queueRepository: context.read<QueueEntryRepository>(),
        restaurantRepository: context.read<RestaurantRepository>(),
        userProvider: context.read<UserProvider>(),
        customerRepository: context.read<CustomerRepositoryImpl>(),
        queueService: context.read<QueueService>()
      ),
      child: ConfirmTicketContent(queueEntryId: queueEntryId),
    );
  }
}
