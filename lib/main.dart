import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repo_mock.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
// import 'package:queue_station_app/firebase_options.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/screens/map/map_screen.dart';
import 'package:queue_station_app/ui/theme/global_scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/normal_user_app.dart';
import 'package:queue_station_app/ui/screens/auth/login_screen.dart';
import 'package:queue_station_app/ui/screens/auth/register_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/account/account.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/confirm_ticket_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/instruction_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  final GoRouter goRouter = GoRouter(
    // --- THIS IS REQUIRED FOR GO_ROUTER DEEP LINKS TO WORK ---
    // If you don't add this, go_router won't parse the deep link.
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (context, state) {
          User user = context.read<UserProvider>().currentUser!;
          return user is Customer ? NormalUserApp() : StoreMainScreen();
        },
        redirect: (context, state) {
          bool isLoggedIn = context.read<UserProvider>().currentUser != null;
          // if (!isLoggedIn) return "/login";
          if (!isLoggedIn) {
            // --- NEW: Save the exact URL they were trying to visit! ---
            // If they clicked /map?id=123, we encode it and pass it to the login screen.
            final String targetUrl = Uri.encodeComponent(state.uri.toString());
            return "/login?from=$targetUrl";
          }
          return null;
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
          // --- PERFECTED MAP ROUTE ---
          GoRoute(
            path: "map",
            builder: (context, state) {
              //http://localhost:55555/map?id=test-id-2
              final String? deepLinkId = state.uri.queryParameters['id'];

              final user = context.read<UserProvider>().currentUser;
              String? myStoreId;

              if (user != null && user is StoreUser) {
                // For testing
                // myStoreId = "test-id-1";
                //real
                myStoreId = user.rest.id;
              }

              return MapScreen(
                initialRestaurantId: deepLinkId,
                ownRestaurantId: myStoreId,
              );
            },
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
              Customer? user = context.read<UserProvider>().asCustomer;
              bool isLoggedIn = user != null;

              if (!isLoggedIn) return "/login";
              if (user.currentHistory == null) return "/";
              return null;
            },
            builder: (context, state) {
              UserProvider userProvider = context.read<UserProvider>();
              Customer? user = userProvider.asCustomer;
              return ConfirmTicketScreen(
                user: user!,
                history: user.currentHistory!,
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
        Provider<RestaurantRepository>(
          create: (_) => MockRestaurantRepository(),
        ),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProxyProvider<OrderProvider, CartProvider>(
          create: (_) => CartProvider(
            currentOrder: Order(id: '', timestamp: DateTime.now()),
          ),
          update: (context, orderProvider, previousCart) {
            final cart =
                previousCart ??
                CartProvider(currentOrder: orderProvider.currentOrder);

            cart.updateOrder(orderProvider.currentOrder);
            return cart;
          },
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StoreOrderNotificationProvider()),
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

Future<bool> _checkHasSeenInstruction() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenFoodInstruction') ?? false;
}

Future<void> _setHasSeenInstruction() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenFoodInstruction', true);
}
