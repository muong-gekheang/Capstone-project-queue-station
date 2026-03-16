import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/store_queue_screen.dart';

import '../ui/screens/store_side/dashboard/dashboard_screen.dart';
import '../ui/screens/store_side/settings/store_settings_screen.dart';
import '../ui/widgets/store_side_bottom_nav.dart';
import 'screens/store_side/store_management/manage_store/manage_store_screen.dart';

enum NavTab { dashboard, analytics, queue, settings }

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({super.key});

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  NavTab _selectedTab = NavTab.dashboard;

  @override
  void initState() {
    super.initState();
  }

  void _onTabSelected(NavTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void onManageQueue() {
    setState(() {
      _selectedTab = NavTab.queue;
    });
  }

  int _getTabIndex(NavTab tab) {
    switch (tab) {
      case NavTab.dashboard:
        return 0;
      case NavTab.analytics:
        return 1;
      case NavTab.queue:
        return 2;
      case NavTab.settings:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return MultiProvider(
      providers: [
        ProxyProvider<UserProvider, RestaurantService>(
          update: (context, userProvider, prev) {
            if (prev == null) {
              return RestaurantService(
                userProvider: userProvider,
                restaurantRepository: context.read<RestaurantRepository>(),
              );
            }
            prev.updateDependencies(userProvider);
            return prev;
          },
          dispose: (context, value) => value.dispose(),
        ),

        ProxyProvider<UserProvider, StoreProfileService>(
          update: (context, userProvider, prev) {
            if (prev == null) {
              return StoreProfileService(
                userProvider: userProvider,
                userRepository: context.read<UserRepository<StoreUser>>(),
              );
            }
            prev.updateDependencies(userProvider);
            return prev;
          },
        ),

        ProxyProvider<UserProvider, TableService>(
          update: (context, newUserProvider, prev) {
            if (prev == null) {
              return TableService(
                userProvider: newUserProvider,
                queueTableRepository: context.read<QueueTableRepository>(),
                tableCategoryRepository: context
                    .read<TableCategoryRepository>(),
              );
            }
            prev.updateDependencies(newUserProvider);
            return prev;
          },
          dispose: (context, value) => value.dispose(),
        ),

        ProxyProvider<UserProvider, MenuService>(
          update: (context, newUserProvider, prev) {
            if (prev == null) {
              return MenuService(
                userProvider: newUserProvider,
                menuItemRepository: context.read<MenuItemRepository>(),
                menuCategoryRepository: context.read<MenuCategoryRepository>(),
                addOnRepository: context.read<AddOnRepository>(),
                sizingOptionRepository: context.read<SizingOptionRepository>(),
              );
            }
            prev.updateDependencies(newUserProvider);

            return prev;
          },
          dispose: (context, value) => value.dispose(),
        ),

        ProxyProvider2<UserProvider, TableService, QueueService>(
          update: (context, userProvider, tableService, prev) {
            if (prev == null) {
              return QueueService(
                userProvider: userProvider,
                queueEntryRepository: context.read<QueueEntryRepository>(),
                tableService: tableService,
              );
            }
            prev.updateDependencies(userProvider);
            return prev;
          },
          dispose: (context, value) => value.dispose(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _getTabIndex(_selectedTab),
          children: [
            DashboardScreen(onManageQueue: onManageQueue),
            ManageStoreScreen(onManageQueue: onManageQueue),
            StoreQueueScreen(),
            StoreSettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedTab: _selectedTab,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
