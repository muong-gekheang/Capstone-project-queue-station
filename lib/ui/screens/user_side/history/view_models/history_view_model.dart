import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/restaurant_repository.dart';
import 'package:queue_station_app/data/repositories/user/customer_repository_impl.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/services/user_provider.dart';

class HistoryViewModel extends ChangeNotifier {
  final CustomerRepositoryImpl customerRepo;
  final QueueEntryRepository queueRepo;
  final RestaurantRepository restaurantRepo;
  final OrderRepository orderRepo;
  final MenuItemRepository menuItemRepository;
  final UserProvider userProvider;

  HistoryViewModel({
    required this.customerRepo,
    required this.queueRepo,
    required this.restaurantRepo,
    required this.orderRepo,
    required this.menuItemRepository,
    required this.userProvider
  }) {
    loadHistory();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Customer? _customer;
  Customer? get customer => _customer;

  List<QueueEntry> _history = [];
  List<QueueEntry> get history => _history;

  final Map<String, Restaurant> _restaurants = {};
  Map<String, Restaurant> get restaurants => _restaurants;

  final Map<String, Order> _orders = {};
  Map<String, Order> get orders => _orders;

  final Map<String, MenuItem> _menuItems = {};
  Map<String, MenuItem> get menuItems => _menuItems;

  double getTotalPriceForQueueEntry(String queueEntryId) {
    final entry = _history.firstWhere(
      (e) => e.id == queueEntryId,
      orElse: () => throw Exception('Queue entry not found'),
    );

    if (entry.orderId == null) return 0.0;

    final order = _orders[entry.orderId!];
    if (order == null) return 0.0;

    double total = 0.0;
    for (final item in order.ordered) {
      // Only count accepted items if you want to filter by status
      // if (item.orderItemStatus == OrderItemStatus.accepted) {
      total += item.calculateTotalPrice();
      // }
    }
    return total;
  }

  // Future<void> loadHistory() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   _customer = userProvider.asCustomer;
  //   if (_customer == null) {
  //     print('❌ No customer found');
  //     _isLoading = false;
  //     notifyListeners();
  //     return;
  //   }

  //   print('✅ Customer found: ${_customer!.id}');
  //   print('Loading queue history...');

  //   // 2️⃣ Load queue history for the user
  //   final (queueList, _) = await queueRepo.getByCustomerId(
  //     _customer!.id,
  //     50,
  //     null,
  //   );

  //   print('📊 Queue entries found: ${queueList.length}');
  //   for (var entry in queueList) {
  //     print(
  //       '  - Entry ID: ${entry.id}, Restaurant: ${entry.restId}, Status: ${entry.status}',
  //     );
  //   }

  //   _history = queueList;

  //   // 3️⃣ Load restaurant and order for each queue entry
  //   for (final entry in _history) {
  //     print('Loading details for entry: ${entry.id}');

  //     if (!_restaurants.containsKey(entry.restId)) {
  //       print('  Loading restaurant: ${entry.restId}');
  //       final rest = await restaurantRepo.getById(entry.restId);
  //       if (rest != null) {
  //         _restaurants[entry.restId] = rest;
  //         print('  ✅ Restaurant loaded: ${rest.name}');
  //       } else {
  //         print('  ❌ Restaurant not found: ${entry.restId}');
  //       }
  //     }

  //     if (entry.orderId != null && !_orders.containsKey(entry.orderId)) {
  //       print('  Loading order: ${entry.orderId}');
  //       final order = await orderRepo.getOrderById(entry.orderId!);
  //       if (order != null) {
  //         print('  ✅ Order loaded: ${order.id}');
  //         List<OrderItem> orderedItems = [];

  //         for (final orderItemId in order.orderedIds) {
  //           print('    Loading order item: $orderItemId');
  //           final orderItem = await orderRepo.getOrderItemById(
  //             order.id,
  //             orderItemId,
  //           );
  //           if (orderItem != null) {
  //             orderedItems.add(orderItem);
  //             print('    ✅ Order item loaded: ${orderItem.menuItemId}');

  //             if (!_menuItems.containsKey(orderItem.menuItemId)) {
  //               print('      Loading menu item: ${orderItem.menuItemId}');
  //               final menuItem = await menuItemRepository.getMenuItemById(
  //                 orderItem.menuItemId,
  //               );
  //               if (menuItem != null) {
  //                 _menuItems[orderItem.menuItemId] = menuItem;
  //                 print('      ✅ Menu item loaded: ${menuItem.name}');
  //               }
  //             }
  //           }
  //         }

  //         final fullOrder = order.copyWith(ordered: orderedItems);
  //         _orders[entry.orderId!] = fullOrder;
  //       } else {
  //         print('  ❌ Order not found: ${entry.orderId}');
  //       }
  //     }
  //   }

  //   print('✅ History loading complete');
  //   print('Restaurants loaded: ${_restaurants.length}');
  //   print('Orders loaded: ${_orders.length}');
  //   print('Menu items loaded: ${_menuItems.length}');

  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _customer = userProvider.asCustomer;
    if (_customer == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 2️⃣ Load queue history for the user
    final (queueList, _) = await queueRepo.getByCustomerId(
      _customer!.id,
      50,
      null,
    );
    _history = queueList;

    // 3️⃣ Load restaurant and order for each queue entry
    for (final entry in _history) {
      if (!_restaurants.containsKey(entry.restId)) {
        final rest = await restaurantRepo.getById(entry.restId);
        if (rest != null) _restaurants[entry.restId] = rest;
      }

      if (entry.orderId != null && !_orders.containsKey(entry.orderId)) {
        final order = await orderRepo.getOrderById(entry.orderId!);
        if (order != null) {
          List<OrderItem> orderedItems = [];

          for (final orderItemId in order.orderedIds) {
            final orderItem = await orderRepo.getOrderItemById(
              order.id,
              orderItemId,
            );
            if (orderItem != null) {
              orderedItems.add(orderItem);

              if (!_menuItems.containsKey(orderItem.menuItemId)) {
                final menuItem = await menuItemRepository.getMenuItemById(
                  orderItem.menuItemId,
                );
                if (menuItem != null) {
                  _menuItems[orderItem.menuItemId] = menuItem;
                }
              }
            }
          }

          final fullOrder = order.copyWith(ordered: orderedItems);

          _orders[entry.orderId!] = fullOrder;
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Restaurant? getRestaurant(String restId) => _restaurants[restId];
  Order? getOrder(String orderId) => _orders[orderId];
}
