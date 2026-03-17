import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository_impl.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_category/menu_category_repository_impl.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_item/menu_item_repository_impl.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository_impl.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order/order_repository_impl.dart';
import 'package:queue_station_app/data/repositories/order/order_repository_mock.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository_impl.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_impl.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_mock.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository_impl.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository_impl.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository_impl.dart';
import 'package:queue_station_app/data/repositories/user/production/customer_repository_impl.dart';
import 'package:queue_station_app/data/repositories/user/production/store_user_repository_impl.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/firebase_options.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/auth/auth_screen.dart';
import 'package:queue_station_app/ui/screens/onboard/on_board_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/confirm_ticket_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/instruction_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/theme/global_scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<SingleChildWidget> dependencies = [
  Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
  Provider<AddOnRepository>(create: (_) => AddOnRepositoryImpl()),
  Provider<RestaurantRepository>(create: (_) => RestaurantRepositoryImpl()),
  Provider<MenuCategoryRepository>(create: (_) => MenuCategoryRepositoryImpl()),
  Provider<MenuItemRepository>(create: (_) => MenuItemRepositoryImpl()),
  Provider<OrderRepository>(create: (_) => OrderRepositoryMock()),
  Provider<QueueEntryRepository>(create: (_) => QueueEntryRepositoryImpl()),
  Provider<QueueTableRepository>(create: (_) => QueueTableRepositoryImpl()),
  Provider<TableCategoryRepository>(
    create: (_) => TableCategoryRepositoryImpl(),
  ),
  Provider<UserRepository<Customer>>(create: (_) => CustomerRepositoryImpl()),
  Provider<UserRepository<StoreUser>>(create: (_) => StoreUserRepositoryImpl()),
  Provider<SizingOptionRepository>(create: (_) => SizingOptionRepositoryImpl()),
  Provider<OrderRepository>(create: (_) => OrderRepositoryImpl()),
  Provider<OrderItemRepository>(create: (_) => OrderItemRepositoryImpl()),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.authStateChanges().first;

  final userProvider = UserProvider();
  // await seedDatabase(clearExisting: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProxyProvider<OrderProvider, CartProvider>(
          create: (_) => CartProvider(
            currentOrder: Order(
              id: '',
              timestamp: DateTime.now(),
              restaurantId: '',
            ),
          ),
          update: (context, orderProvider, previousCart) {
            final cart =
                previousCart ??
                CartProvider(currentOrder: orderProvider.currentOrder);

            cart.updateOrder(orderProvider.currentOrder);
            return cart;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => StoreOrderNotificationProvider(
            orderRepository: OrderRepositoryMock(),
          ),
        ),
        ...dependencies,

        ProxyProvider4<
          UserProvider,
          UserRepository<Customer>,
          UserRepository<StoreUser>,
          AuthRepository,
          AuthService
        >(
          update:
              (
                context,
                userProvider,
                customerRepository,
                storeUserRepository,
                authRepository,
                previous,
              ) {
                if (previous == null) {
                  return AuthService(
                    authRepository: authRepository,
                    userProvider: userProvider,
                    customerRepository: customerRepository,
                    storeUserRepository: storeUserRepository,
                  );
                }
                previous.updateDependencies(
                  authRepository: authRepository,
                  userProvider: userProvider,
                  customerRepository: customerRepository,
                  storeUserRepository: storeUserRepository,
                );
                return previous;
              },
        ),
      ],
      child: Builder(
        builder: (context) {
          context.read<AuthService>().restoreSession();
          return MaterialApp.router(
            title: "Queue Station",
            scrollBehavior: GlobalScrollBehavior(),
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: GoRouter(
              initialLocation: "/onboard",
              refreshListenable: userProvider,

              redirect: (context, state) async {
                if (userProvider.isRestoring) return '/onboard';

                final bool loggedIn = userProvider.currentUser != null;
                final bool isLoggingIn = state.matchedLocation == '/auth';
                final bool isSplash = state.matchedLocation == '/onboard';

                // Once restored, leave the splash screen
                if (!isSplash && loggedIn == false) return '/auth';
                if (isSplash && !userProvider.isRestoring) {
                  return loggedIn ? '/' : '/auth';
                }
                if (isLoggingIn && loggedIn) return '/';

                return null;
              },
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (context, state) {
                    User user = context.read<UserProvider>().currentUser!;
                    return user is Customer ? Placeholder() : StoreMainScreen();
                  },
                ),
                GoRoute(
                  path: "/onboard",
                  builder: (context, state) {
                    return OnBoardScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: "menu",
                      builder: (context, state) => FutureBuilder<bool>(
                        future: _checkHasSeenInstruction(),
                        builder: (context, snapshot) {
                          final hasSeenInstruction = snapshot.data ?? false;

                          if (!hasSeenInstruction) {
                            // Show instruction if not seen
                            return Instruction(
                              onContinue: () async {
                                await _setHasSeenInstruction();
                                // Navigate to menu after continue
                                context.go('/menu');
                              },
                            );
                          }

                          return const MenuScreen();
                        },
                      ),
                    ),

                    GoRoute(
                      path: "map",
                      builder: (context, state) => Placeholder(),
                    ),
                    GoRoute(
                      path: "order",
                      builder: (context, state) => const OrderScreen(),
                    ),
                    GoRoute(
                      path: "account",
                      builder: (context, state) => const Account(),
                    ),
                    GoRoute(
                      path: "ticket",
                      redirect: (context, state) {
                        Customer? user = context
                            .read<UserProvider>()
                            .asCustomer;
                        bool isLoggedIn = user != null;

                        if (!isLoggedIn) return "/login";
                        if (user.currentHistoryId == null) return "/";
                        return null;
                      },
                      builder: (context, state) {
                        UserProvider userProvider = context
                            .read<UserProvider>();
                        Customer? user = userProvider.asCustomer;

                        return ConfirmTicketScreen(
                          user: user!,
                          queueEntry:
                              mockQueueEntries[0], // TODO: USE MVVM TO handle this
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: "/auth",
                  builder: (context, state) => AuthScreen(),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<bool> _checkHasSeenInstruction() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenFoodInstruction') ?? false;
}

Future<void> _setHasSeenInstruction() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenFoodInstruction', true);
}
