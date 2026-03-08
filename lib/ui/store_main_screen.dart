import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/store/queue_service.dart';
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

  List<Widget> get _screens => [
    DashboardScreen(),
    ManageStoreScreen(),
    StoreQueueScreen(),
    StoreSettingsScreen(),
  ];

  void _onTabSelected(NavTab tab) {
    setState(() {
      _selectedTab = tab;
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
    RestaurantRepository restaurantRepository = context
        .read<RestaurantRepository>();

    UserRepository<StoreUser> userRepository = context
        .read<UserRepository<StoreUser>>();

    QueueEntryRepository queueEntryRepository = context
        .read<QueueEntryRepository>();

    QueueTableRepository queueTableRepository = context
        .read<QueueTableRepository>();
    return MultiProvider(
      providers: [
        ProxyProvider<UserProvider, RestaurantService>(
          update: (context, userProvider, restaurantService) {
            return RestaurantService(
              userProvider: userProvider,
              restaurantRepository: restaurantRepository,
            );
          },
          dispose: (context, value) => value.dispose(),
        ),

        ProxyProvider<UserProvider, QueueService>(
          update: (context, userProvider, queueService) => QueueService(
            userProvider: userProvider,
            queueEntryRepository: queueEntryRepository,
          ),
          dispose: (context, value) => value.dispose(),
        ),

        ProxyProvider<UserProvider, StoreProfileService>(
          update: (context, userProvider, restaurantService) {
            return StoreProfileService(
              userProvider: userProvider,
              userRepository: userRepository,
            );
          },
        ),

        ProxyProvider<UserProvider, TableService>(
          update: (context, userProvider, queueService) => TableService(
            userProvider: userProvider,
            queueTableRepository: queueTableRepository,
          ),
          dispose: (context, value) => value.dispose(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _getTabIndex(_selectedTab),
          children: _screens,
        ),
        bottomNavigationBar: BottomNavBar(
          selectedTab: _selectedTab,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
