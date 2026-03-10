import 'package:queue_station_app/data/repositories/order/order_repository.dart';

class OrderService {
  final OrderRepository _orderRepository;

  OrderService({required OrderRepository orderRepository})
    : _orderRepository = orderRepository;
}
