import 'dart:async';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class OrderService {
  UserProvider _userProvider;
  final OrderRepository _orderRepository;
  final OrderItemRepository _orderItemRepository;
  MenuService _menuService;
  final QueueEntryRepository _queueRepository;

  final StreamController<List<Order>> _orderController = BehaviorSubject<List<Order>>.seeded([]);
  StreamSubscription<List<Order>>? _orderSubscription;
  final _currentOrderController = BehaviorSubject<Order?>();
  StreamSubscription<Order?>? _orderSub;

  Stream<Order?> get streamCurrentOrder => _currentOrderController.stream;

  StreamSubscription<QueueEntry?>? _queueSub;

  String? _activeOrderId;

  OrderService({
    required OrderRepository orderRepository,
    required MenuService menuService,
    required OrderItemRepository orderItemRepository,
    required UserProvider userProvider,
    required QueueEntryRepository queueRepository,
  }) : _orderRepository = orderRepository,
       _menuService = menuService,
       _orderItemRepository = orderItemRepository,
       _userProvider = userProvider,
       _queueRepository = queueRepository;

  String? get restId => _userProvider.asStoreUser?.restaurantId;

  Stream<List<Order>> get streamTodayOrders => _orderController.stream;

  void initStream() {
    if (restId != null) {
      _orderSubscription = _orderRepository
          .watchTodayOrders(restId!)
          .listen(
            (data) {
              debugPrint("Order: ${data.length}");
              _orderController.add(data);
              todayOrder = data;
            },
            onError: (err) {
              _orderController.addError(err);
              debugPrint("Order ERR: $err");
            },
          );
    }
  }

  void listenToQueue(String queueHistoryId) {
    _queueSub?.cancel();
    _orderSub?.cancel();
    _activeOrderId = null;

    _queueSub = _queueRepository
        .watchQueueEntry(queueHistoryId)
        .listen(_handleQueueUpdate);
  }

  // ---------------------------
  // Handle queue changes
  // ---------------------------
  Future<void> _handleQueueUpdate(QueueEntry? queueEntry) async {
    if (queueEntry == null) {
      _emit(null);
      return;
    }

    switch (queueEntry.status) {
      case QueueStatus.waiting:
        _emit(null);
        break;

      case QueueStatus.serving:
        await _handleServing(queueEntry);
        break;

      case QueueStatus.completed:
      case QueueStatus.noShow:
      case QueueStatus.cancelled:
        _orderSub?.cancel();
        _activeOrderId = null;
        _emit(null);
        break;
    }
  }

  Future<void> _handleServing(QueueEntry queueEntry) async {
    String orderId;

    if (queueEntry.orderId == null || queueEntry.orderId!.isEmpty) {
      orderId = await _orderRepository.createEmptyOrder(
        restaurantId: queueEntry.restId,
        queueEntryId: queueEntry.id,
      );
    } else {
      orderId = queueEntry.orderId!;
    }

    if (_activeOrderId == orderId) return;

    _activeOrderId = orderId;
    _subscribeToOrder(orderId);
  }

  // ---------------------------
  // Subscribe to order
  // ---------------------------
  void _subscribeToOrder(String orderId) {
    _orderSub?.cancel();

    _orderSub =
        Rx.combineLatest2<Order?, List<OrderItem>, Order?>(
              _orderRepository.watchOrderById(orderId),
              _orderRepository.watchOrderItems(orderId),
              (order, items) {
                if (order == null) return null;

                final inCartSet = order.inCartIds.toSet();
                final orderedSet = order.orderedIds.toSet();

                return order.copyWith(
                  inCart: items
                      .where((i) => inCartSet.contains(Order.orderItemRef(i)))
                      .toList(),
                  ordered: items
                      .where((i) => orderedSet.contains(Order.orderItemRef(i)))
                      .toList(),
                );
              },
            )
            .distinct(_areOrdersEqual)
            .listen(_emit, onError: _currentOrderController.addError);
  }

  // ---------------------------
  // Save Order
  // ---------------------------
  Future<void> saveOrder(Order order) async {
    await _orderRepository.saveOrder(order);
  }

  // ---------------------------
  // Helpers
  // ---------------------------
  void _emit(Order? order) {
    _currentOrderController.add(order);
  }

  bool _areOrdersEqual(Order? a, Order? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    return a.inCartIds.toString() == b.inCartIds.toString() &&
        a.orderedIds.toString() == b.orderedIds.toString();
  }

  void updateDependencies(UserProvider userProvider, MenuService menuService) {
    _userProvider = userProvider;
    _menuService = menuService;
    if (restId != null) {
      initStream();
    }
  }

  void dispose() {
    _orderController.close();
    _currentOrderController.close();
    _orderSubscription?.cancel();
    _orderSub?.cancel();
  }

  Future<Order?> getOrderDetailsById(String orderId) async {
    Order? initOrder = await _orderRepository.getOrderById(orderId);
    if (initOrder == null) return null;

    debugPrint("Order:  ${initOrder.id}");

    List<OrderItem> orderItems = await _orderItemRepository
        .getOrderItemByOrderId(orderId);

    List<OrderItem> filledOrderItems = [];
    for (var item in orderItems) {
      MenuItem? menuItem = _menuService.menuItemsMap[item.menuItemId];

      menuItem ??= await _menuService.getMenuItemById(item.menuItemId);
      filledOrderItems.add(item.copyWith(menuItem: menuItem));
    }
    debugPrint(
      "Order: Copy ${initOrder.copyWith(ordered: filledOrderItems).id}",
    );
    return initOrder.copyWith(ordered: filledOrderItems);
  }

  List<Order> todayOrder = [];

   bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}
