import '../models/order/order_item.dart';

String orderItemRef(OrderItem item) {
  return '${item.menuItemId}_${item.sizeName}_${item.quantity}';
}
