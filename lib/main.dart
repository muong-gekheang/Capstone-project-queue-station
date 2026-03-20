import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/authentication/auth_repository.dart';
import 'package:queue_station_app/data/repositories/authentication/auth_repository_impl.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order/order_repository_impl.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository_impl.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_category/menu_category_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_category/menu_category_repository_impl.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item/menu_item_repository_impl.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant/restaurant_repository_impl.dart';
import 'package:queue_station_app/data/repositories/user/customer_repository_impl.dart';
import 'package:queue_station_app/firebase_options.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order/order_screen.dart';
import 'package:queue_station_app/ui/theme/global_scroll_behavior.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/normal_user_app.dart';
import 'package:queue_station_app/ui/screens/auth/login_screen.dart';
import 'package:queue_station_app/ui/screens/auth/register_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/confirm_ticket_screen.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await seedDatabase(clearExisting: true); 
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (context, state) {
          User user = context.read<UserProvider>().currentUser!;
          return user is Customer ? NormalUserApp() : StoreMainScreen();
        },
        redirect: (context, state) {
          bool isLoggedIn = context.read<UserProvider>().currentUser != null;
          if (!isLoggedIn) return "/login";
          return null;
        },
        routes: <RouteBase>[
          GoRoute(
            path: "menu",
            builder: (context, state) => const MenuScreen(),
          ),
          GoRoute(path: "map", builder: (context, state) => Placeholder()),
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
              Customer? user = context.read<UserProvider>().asCustomer;
              if (user == null) return "/login";
              if (user.currentHistoryId == null) return "/";

              return null;
            },
            builder: (context, state) {
              Customer user = context.read<UserProvider>().asCustomer!;
              // Pass the ID string, NOT the object
              return ConfirmTicketScreen(
                queueEntryId: user.currentHistoryId!,
              );
            },
          ),
        ],
      ),
      GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    ],
  );
  runApp(
    MultiProvider(
      providers: [
        // --- 1. DATA LAYER (Repositories) ---
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<OrderRepository>(create: (_) => OrderRepositoryImpl()),
        Provider<MenuCategoryRepository>(
          create: (_) => MenuCategoryRepositoryImpl(),
        ),
        Provider<MenuItemRepository>(create: (_) => MenuItemRepositoryImpl()),
        Provider<RestaurantRepository>(
          create: (_) => RestaurantRepositoryImpl(),
        ),
        Provider<QueueEntryRepository>(
          create: (_) => QueueEntryRepositoryImpl(),
        ),
        Provider(create: (_) => CustomerRepositoryImpl()),

        // --- 2. INDEPENDENT STATE ---
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StoreOrderNotificationProvider()),
        Provider<QueueEntryRepository>(create: (_) => QueueEntryRepositoryImpl()),

        // --- 3. DEPENDENT STATE ---
        ChangeNotifierProxyProvider<UserProvider, OrderProvider>(
          create: (context) => OrderProvider(
            currentOrder: Order.empty(),
            orderRepository: context.read<OrderRepository>(),
            userProvider: context.read<UserProvider>(),
          ),
          update: (_, user, order) => order!..updateUserProvider(user),
        ),
      ],
      child: MaterialApp.router(
        scrollBehavior: GlobalScrollBehavior(),
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    ),
  );
}
