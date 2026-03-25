import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    try {
      final querySnapShot = await firestore
          .collection("order_items")
          .where('orderId', isEqualTo: orderId)
          .get();

      return querySnapShot.docs.map((doc) {
        final json = doc.data();
        json['id'] = doc.id;
        debugPrint("Order Item: $json");
        return OrderItem.fromJson(json);
      }).toList();
    } catch (err) {
      debugPrint("Order Item: Err $err");
      rethrow;
    }
  }

  @override
  Future<OrderItem> update(OrderItem orderItem) async {
    final orderItemRef = firestore.collection('order_items').doc(orderItem.id);
    await orderItemRef.update(orderItem.toJson());
    return orderItem;
  }
}
