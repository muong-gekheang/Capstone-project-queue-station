import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/order_item/order_item_repository.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final FirebaseFirestore firestore;

  OrderItemRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> create(OrderItem orderItem) async {
    final orderItemRef = firestore.collection('order_items').doc(orderItem.id);
    await orderItemRef.set(orderItem.toJson());
  }

  @override
  Future<void> delete(String orderItemId) async {
    await firestore.collection("order_items").doc(orderItemId).delete();
  }

  @override
  Future<List<OrderItem>> getOrderItemByOrderId(String orderId) async {
    final querySnapShot = await firestore
        .collection("order_items")
        .where('orderId', isEqualTo: orderId)
        .get();

    return querySnapShot.docs.map((doc) {
      return OrderItem.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<OrderItem> update(OrderItem orderItem) async {
    final orderItemRef = firestore.collection('order_items').doc(orderItem.id);
    await orderItemRef.update(orderItem.toJson());
    return orderItem;
  }
}
