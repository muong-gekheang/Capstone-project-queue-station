import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/services/customer_menu_service.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/menu/view_models/menu_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/menu/widgets/menu_content.dart';
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuViewModel>(
      create: (_) {
        final viewModel = MenuViewModel(
          queueEntryRepository: context.read<QueueEntryRepository>(),
          userProvider: context.read<UserProvider>(),
          restaurantRepository: context.read<RestaurantRepository>(), 
          menuService: CustomerMenuService(
            menuItemRepository: context.read<MenuItemRepository>(), 
            menuCategoryRepository: context.read<MenuCategoryRepository>(), 
            addOnRepository: context.read<AddOnRepository>(), 
            menuSizeRepository: context.read<MenuSizeRepository>(), 
            sizingOptionRepository: context.read<SizingOptionRepository>()
          ), 
          orderProvider: context.read<OrderProvider>()
        );
        // Initialize after creation
        viewModel.initialize();
        return viewModel;
      },
      child: const MenuContent(),
    );
  }
}
