import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/store/menu_service.dart';

class OrderService {
  final OrderRepository _orderRepository;
  final OrderItemRepository _orderItemRepository;
  final MenuService _menuService;

  OrderService({
    required OrderRepository orderRepository,
    required MenuService menuService,
    required OrderItemRepository orderItemRepository,
  }) : _orderRepository = orderRepository,
       _menuService = menuService,
       _orderItemRepository = orderItemRepository;

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
}
