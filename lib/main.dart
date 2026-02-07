import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/old_model/user.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/normal_user_app.dart';
import 'package:queue_station_app/ui/screens/auth/login_screen.dart';
import 'package:queue_station_app/ui/screens/auth/register_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/confirm_ticket/confirm_ticket_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';

void main() {
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (context, state) {
          User user = context.read<UserProvider>().currentUser!;
          return user.userType == UserType.normal
              ? NormalUserApp()
              : StoreMainScreen();
        },
        redirect: (context, state) {
          bool isLoggedIn = context.read<UserProvider>().currentUser != null;
          if (!isLoggedIn) return "/login";
          return null;
        },
        routes: <RouteBase>[
          GoRoute(path: "map", builder: (context, state) => Placeholder()),
          GoRoute(path: "order", builder: (context, state) => OrderScreen()),
          GoRoute(
            path: "ticket",
            redirect: (context, state) {
              User? user = context.read<UserProvider>().currentUser;
              bool isLoggedIn = user != null;

              if (!isLoggedIn) return "/login";
              if (!user.isJoinedQueue) return "/";
              return null;
            },
            builder: (context, state) {
              UserProvider userProvider = context.read<UserProvider>();
              User? user = userProvider.currentUser;
              return ConfirmTicketScreen(user: user!, rest: user.restaurant!);
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
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    ),
  );
}
