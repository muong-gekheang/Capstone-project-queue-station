import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

class OrderRepositoryImpl extends OrderRepository {
  final FirebaseFirestore fireStore;

  OrderRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orderCol =>
      fireStore.collection('orders');

  CollectionReference<Map<String, dynamic>> get _itemCol =>
      fireStore.collection('order_items');

  // ---------------------------
  // MAPPER
  // ---------------------------

  Order? _map(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (!doc.exists || doc.data() == null) return null;

    try {
      return Order.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      debugPrint('❌ Parse Order ${doc.id}: $e');
      return null;
    }
  }

  // CREATE ORDER
  @override
  Future<void> create(Order order) async {
    final orderRef = _orderCol.doc(order.id);

    await fireStore.runTransaction((txn) async {
      txn.set(orderRef, {
        'id': order.id,
        'timestamp': order.timestamp.toIso8601String(),
        'restaurantId': order.restaurantId,
        'inCartIds': order.inCart.map(Order.orderItemRef).toList(),
        'orderedIds': order.ordered.map(Order.orderItemRef).toList(),
      });

      for (final item in order.inCart) {
        final itemDocId = '${order.id}_${Order.orderItemRef(item)}';
        txn.set(
          _orderCol.doc(itemDocId),
          item.toJson()..['orderId'] = order.id,
        );
      }

      for (final item in order.ordered) {
        final itemDocId = '${order.id}_${Order.orderItemRef(item)}';
        txn.set(
          _orderCol.doc(itemDocId),
          item.toJson()..['orderId'] = order.id,
        );
      }
    });
  }

  @override
  Future<String> createEmptyOrder({
    required String restaurantId,
    required String queueEntryId,
  }) async {
    final orderRef = _orderCol.doc();

    await fireStore.runTransaction((txn) async {
      txn.set(orderRef, {
        'restaurantId': restaurantId,
        'timestamp': FieldValue.serverTimestamp(),
        'inCartIds': [],
        'orderedIds': [],
      });

      txn.update(fireStore.collection('queue_entries').doc(queueEntryId), {
        'orderId': orderRef.id,
      });
    });

    return orderRef.id;
  }

  // ---------------------------
  // SAVE / UPDATE ORDER
  // ---------------------------

  @override
  Future<void> saveOrder(Order order) async {
    final orderRef = _orderCol.doc(order.id);
    final batch = fireStore.batch();

    // ✅ Always use SAME ID STRATEGY
    final inCartIds = order.inCart.map(Order.orderItemRef).toList();
    final orderedIds = order.ordered.map(Order.orderItemRef).toList();

    // 1. Save order doc
    batch.set(orderRef, {
      'restaurantId': order.restaurantId,
      'timestamp': FieldValue.serverTimestamp(),
      'inCartIds': inCartIds,
      'orderedIds': orderedIds,
    }, SetOptions(merge: true));

    // 2. Save items
    for (final item in [...order.inCart, ...order.ordered]) {
      final docId = '${order.id}_${Order.orderItemRef(item)}';

      batch.set(
        _itemCol.doc(docId),
        item.toJson()..['orderId'] = order.id,
        SetOptions(merge: true),
      );
    }

    final existingItemsSnap = await _itemCol
        .where('orderId', isEqualTo: order.id)
        .get();

    final existingIds = existingItemsSnap.docs.map((d) => d.id).toSet();

    final newIds = {
      ...inCartIds.map((id) => '${order.id}_$id'),
      ...orderedIds.map((id) => '${order.id}_$id'),
    };

    for (final docId in existingIds.difference(newIds)) {
      batch.delete(_itemCol.doc(docId));
    }

    await batch.commit();
  }

  @override
  Future<OrderItem?> getOrderItemById(String orderId, String orderedId) async {
    final docId = '${orderId}_$orderedId';
    final doc = await _itemCol.doc(docId).get();

    if (!doc.exists) return null;
    doc.data()!['id'] = docId;

    return OrderItem.fromJson(doc.data()!);
  }

  @override
  Stream<List<OrderItem>> watchOrderItems(String orderId) {
    return _itemCol
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OrderItem.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  @override
  Future<void> confirmOrder(String orderId) async {
    final orderRef = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snap = await txn.get(orderRef);
      if (!snap.exists) return;

      final inCart = List<String>.from(snap.data()?['inCartIds'] ?? []);
      final ordered = List<String>.from(snap.data()?['orderedIds'] ?? []);

      txn.update(orderRef, {
        'inCartIds': [],
        'orderedIds': [...ordered, ...inCart],
        'lastConfirmedAt': FieldValue.serverTimestamp(),
      });

      for (final ref in inCart) {
        // Updates the status of the STABLE docId
        txn.update(_itemCol.doc('${orderId}_$ref'), {'status': 'ordered'});
      }
    });
  }

  @override
  Stream<Order?> watchOrderById(String orderId) {
    return _orderCol.doc(orderId).snapshots().map(_map);
  }

  @override
  Stream<List<Order>> watchAllOrder() {
    return _orderCol.snapshots().map(
      (snap) => snap.docs.map(_map).whereType<Order>().toList(),
    );
  }

  @override
  Stream<List<Order>> watchTodayOrders(String restId) {
    final startOfDay = Timestamp.fromDate(
      DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
    );

    return _orderCol
        .where('restaurantId', isEqualTo: restId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .snapshots()
        .map((snap) => snap.docs.map(_map).whereType<Order>().toList());
  }

  @override
  Future<Order?> getOrderById(String orderId) async {
    final doc = await _orderCol.doc(orderId).get();
    return _map(doc);
  }
  
  @override
  Future<void> delete(String orderId) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  
  @override
  Future<Order> update(Order order) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateOrderedItemStatus(String orderId, String menuItemId, OrderItemStatus status) {
    // TODO: implement updateOrderedItemStatus
    throw UnimplementedError();
  }
}
