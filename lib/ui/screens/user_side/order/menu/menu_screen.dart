import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/view_models/menu_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/widgets/menu_content.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuViewModel>(
      create: (_) {
        final viewModel = MenuViewModel(
          menuItemRepository: context.read<MenuItemRepository>(),
          orderRepository: context.read<OrderRepository>(),
          queueEntryRepository: context.read<QueueEntryRepository>(),
          menuCategoryRepository: context.read<MenuCategoryRepository>(),
          userProvider: context.read<UserProvider>(),
        );
        // Initialize after creation
        viewModel.initialize();
        return viewModel;
      },
      child: const MenuContent(),
    );
  }
}
