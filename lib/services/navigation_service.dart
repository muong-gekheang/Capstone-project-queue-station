import 'package:flutter/material.dart';

/// A global navigation service that holds the navigator key and provides
/// methods for navigation across the app, especially useful for showing
/// screens from non‑widget contexts (e.g., from push notifications).
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Pushes a new named route onto the navigator.
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pushes a new page (widget) onto the navigator.
  static Future<T?> push<T>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replaces the current route with a new named route.
  static Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pops the current route off the navigator.
  static void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  /// Checks if the navigator is ready (has a current state).
  static bool get isReady => navigatorKey.currentState != null;
}
