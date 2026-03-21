import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/account/view_models/account_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/account/widgets/account_content.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountViewModel>(
      create: (context) {
        final vm = AccountViewModel(
          userProvider: context.read<UserProvider>(),
          queueRepository: context.read<QueueEntryRepository>(),
          restaurantRepository: context.read<RestaurantRepository>(),
        );

        // Load data immediately - user is already in UserProvider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.loadCustomerData();
        });

        return vm;
      },
      child: const AccountContent(),
    );
  }
}
