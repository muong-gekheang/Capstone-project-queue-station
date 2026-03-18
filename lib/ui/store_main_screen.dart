import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/store_queue_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/edit_store_screen.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

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
                menuSizeRepository: context.read<MenuSizeRepository>(),
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
        ProxyProvider<MenuService, OrderService>(
          update: (context, value, previous) => OrderService(
            orderRepository: context.read<OrderRepository>(),
            menuService: value,
            orderItemRepository: context.read<OrderItemRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            // 1. Add the Banner here
            const EmailVerificationBanner(),

            // 2. The rest of your content remains the same
            Expanded(
              child: IndexedStack(
                index: _getTabIndex(_selectedTab),
                children: [
                  DashboardScreen(onManageQueue: onManageQueue),
                  ManageStoreScreen(onManageQueue: onManageQueue),
                  StoreQueueScreen(),
                  StoreSettingsScreen(),
                ],
              ),
            ),
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

class EmailVerificationBanner extends StatelessWidget {
  const EmailVerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.emailVerified) {
      return const SizedBox.shrink();
    }

    return Material(
      color: AppTheme.naturalTextGrey,
      child: SafeArea(
        bottom: false,
        child: ListTile(
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          title: const Text(
            "Account not verified! Verify so you can reset password through email.",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.naturalWhite,
            ),
          ),
          trailing: SizedBox(
            width: 100,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.naturalBlack,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditStoreScreen(
                      restaurantService: context.read<RestaurantService>(),
                      storeProfileService: context.read<StoreProfileService>(),
                    ),
                  ),
                );
              },
              child: const Text(
                "Verify",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
