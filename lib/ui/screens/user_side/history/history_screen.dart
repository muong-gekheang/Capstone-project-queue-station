import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/customer_repository_impl.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/history/view_models/history_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/history/widgets/history_content.dart';

enum SortType { recent, byMonth, byYear }

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryViewModel(
        customerRepo: context.read<CustomerRepositoryImpl>(), 
        queueRepo: context.read<QueueEntryRepository>(), 
        restaurantRepo: context.read<RestaurantRepository>(), 
        orderRepo: context.read<OrderRepository>(),
        menuItemRepository: context.read<MenuItemRepository>(),
        userProvider: context.read<UserProvider>()
      ),
      child: HistoryContent(),
    );
  }
}


