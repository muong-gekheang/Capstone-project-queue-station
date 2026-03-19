import 'dart:async';

import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class OrderService {
  UserProvider _userProvider;
  final OrderRepository _orderRepository;
  final OrderItemRepository _orderItemRepository;
  MenuService _menuService;

  StreamController<List<Order>> _orderController =
      BehaviorSubject<List<Order>>.seeded([]);

  StreamSubscription<List<Order>>? _orderSubscription;

  OrderService({
    required OrderRepository orderRepository,
    required MenuService menuService,
    required OrderItemRepository orderItemRepository,
    required UserProvider userProvider,
  }) : _orderRepository = orderRepository,
       _menuService = menuService,
       _orderItemRepository = orderItemRepository,
       _userProvider = userProvider;

  String? get restId => _userProvider.asStoreUser?.restaurantId;

  void initStream() {
    if (restId != null) {
      _orderSubscription = _orderRepository.watchTodayOrders(restId!).listen((
        data,
      ) {
        _orderController.add(data);
        todayOrder = data;
      }, onError: (err) => _orderController.addError(err));
    }
  }

  void updateDependencies(UserProvider userProvider, MenuService menuService) {
    userProvider = userProvider;
    menuService = menuService;
    if (restId != null) {
      initStream();
    }
  }

  void dispose() {
    _orderController.close();
    _orderSubscription?.cancel();
  }

  Future<Order?> getOrderDetailsById(String orderId) async {
    Order? initOrder = await _orderRepository.getOrderById(orderId);
    if (initOrder == null) return null;

    List<OrderItem> orderItems = await _orderItemRepository
        .getOrderItemByOrderId(orderId);

    List<OrderItem> filledOrderItems = [];
    for (var item in orderItems) {
      MenuItem? menuItem = _menuService.menuItemsMap[item.menuItemId];

      menuItem ??= await _menuService.getMenuItemById(item.menuItemId);
      filledOrderItems.add(item.copyWith(menuItem: menuItem));
    }

    return initOrder.copyWith(ordered: filledOrderItems);
  }

  List<Order> todayOrder = [];
}
