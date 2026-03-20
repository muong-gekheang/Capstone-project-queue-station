import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart'
    as order_model show Order, OrderItem, orderItemRef;
import 'package:queue_station_app/models/order/order_item.dart';

class OrderRepositoryImpl extends OrderRepository {
  final FirebaseFirestore fireStore;

  OrderRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orderCol =>
      fireStore.collection('orders');

  CollectionReference<Map<String, dynamic>> get _orderItemCol =>
      fireStore.collection('order_items');

  order_model.Order? _currentOrder;
  order_model.Order get currentOrder =>
      _currentOrder ??= order_model.Order.empty();
      

  // CREATE ORDER
  @override
  Future<void> create(order_model.Order order) async {
    final orderRef = _orderCol.doc(order.id);

    await fireStore.runTransaction((txn) async {
      // Save the order itself (IDs only)
      txn.set(orderRef, {
        'id': order.id,
        'timestamp': order.timestamp.toIso8601String(),
        'inCartIds': order.inCart.map(order_model.orderItemRef).toList(),
        'orderedIds': order.ordered.map(order_model.orderItemRef).toList(),
      });

      // Save each inCart item
      for (final item in order.inCart) {
        final itemDocId = '${order.id}_${order_model.orderItemRef(item)}';
        txn.set(
          _orderItemCol.doc(itemDocId),
          item.toJson()..['orderId'] = order.id,
        );
      }

      // Save each ordered item
      for (final item in order.ordered) {
        final itemDocId = '${order.id}_${order_model.orderItemRef(item)}';
        txn.set(
          _orderItemCol.doc(itemDocId),
          item.toJson()..['orderId'] = order.id,
        );
      }
    });
    
  }

  @override
  Future<String?> syncCart({
    required String queueEntryId,
    required order_model.Order order,
  }) async {
    // If order is empty, there is nothing to sync
    if (order.inCart.isEmpty && order.id.isEmpty) return null;

    String? createdOrderId;

    await fireStore.runTransaction((transaction) async {
      String targetOrderId = order.id;
      final queueRef = fireStore.collection('queue_entries').doc(queueEntryId);

      // CASE 1: New Order (Link to Queue)
      if (targetOrderId.isEmpty) {
        final newOrderRef = _orderCol.doc(); // Generate new ID
        targetOrderId = newOrderRef.id;

        createdOrderId = targetOrderId; // store it so we can return later

        // Link Order ID to QueueEntry
        transaction.update(queueRef, {'orderId': targetOrderId});

        // Create the Order document
        transaction.set(newOrderRef, {
          'id': targetOrderId,
          'timestamp': DateTime.now().toIso8601String(),
          'inCartIds': order.inCart.map(order_model.orderItemRef).toList(),
          'orderedIds': [],
        });
      }
      // CASE 2: Update Existing Order
      else {
        final orderRef = _orderCol.doc(targetOrderId);

        transaction.update(orderRef, {
          'inCartIds': order.inCart.map(order_model.orderItemRef).toList(),
        });
      }

      // Sync individual OrderItems
      for (final item in order.inCart) {
        final itemDocId = '${targetOrderId}_${order_model.orderItemRef(item)}';

        transaction.set(
          _orderItemCol.doc(itemDocId),
          item.toJson()..['orderId'] = targetOrderId,
          SetOptions(merge: true),
        );
      }
    });

    return createdOrderId;
  }

  @override
  Future<void> confirmOrder(String orderId) async {
    final orderRef = _orderCol.doc(orderId);

    await fireStore.runTransaction((transaction) async {
      final snapshot = await transaction.get(orderRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> currentInCart = data['inCartIds'] ?? [];
      final List<dynamic> currentOrdered = data['orderedIds'] ?? [];

      // Move IDs from cart to ordered
      transaction.update(orderRef, {
        'inCartIds': [], // Clear cart
        'orderedIds': [...currentOrdered, ...currentInCart], // Move to ordered
        'lastConfirmedAt': DateTime.now().toIso8601String(),
      });

      // Update the status of each individual OrderItem document
      for (String itemRef in currentInCart) {
        final itemDocRef = _orderItemCol.doc('${orderId}_$itemRef');
        transaction.update(itemDocRef, {
          'status': 'ordered', // Or your enum equivalent
          'confirmedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  @override
  Future<OrderItem?> getOrderItemById(String orderId, String orderedId) async {
    try {
      final docId = '${orderId}_$orderedId';

      final doc = await _orderItemCol.doc(docId).get();

      if (!doc.exists) return null;

      return OrderItem.fromJson(doc.data()!);
    } catch (e) {
      print("Error getting order item: $e");
      rethrow;
    }
  }

  // ADD ITEM TO CART
  @override
  Future<void> addItemToCart(String orderId, OrderItem item) async {
    final orderDoc = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snapshot = await txn.get(orderDoc);
      if (!snapshot.exists) throw Exception("Order not found");

      final data = snapshot.data()!;
      final inCartIds = List<String>.from(data['inCartIds'] ?? []);
      inCartIds.add(order_model.orderItemRef(item));

      txn.update(orderDoc, {'inCartIds': inCartIds});

      // Save item in order_items collection
      final itemDocId = '${orderId}_${order_model.orderItemRef(item)}';
      txn.set(
        _orderItemCol.doc(itemDocId),
        item.toJson()..['orderId'] = orderId,
      );
    });
  }

  // MOVE ITEM FROM CART TO ORDERED
  Future<void> moveItemToOrdered(String orderId, OrderItem item) async {
    final orderDoc = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snapshot = await txn.get(orderDoc);
      if (!snapshot.exists) throw Exception("Order not found");

      final data = snapshot.data()!;
      final inCartIds = List<String>.from(data['inCartIds'] ?? []);
      final orderedIds = List<String>.from(data['orderedIds'] ?? []);

      final itemRef = order_model.orderItemRef(item);

      if (inCartIds.remove(itemRef)) {
        orderedIds.add(itemRef);

        txn.update(orderDoc, {
          'inCartIds': inCartIds,
          'orderedIds': orderedIds,
        });

        final itemDoc = _orderItemCol.doc('${orderId}_$itemRef');

        txn.update(itemDoc, {'orderItemStatus': 'accepted'});
      }
    });
  }

  // REMOVE ITEM FROM CART
  @override
  Future<void> removeItemFromCart(String orderId, OrderItem item) async {
    final orderDoc = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snapshot = await txn.get(orderDoc);
      if (!snapshot.exists) throw Exception("Order not found");

      final data = snapshot.data()!;
      final inCartIds = List<String>.from(data['inCartIds'] ?? []);

      final itemRef = order_model.orderItemRef(item);

      inCartIds.remove(itemRef);

      txn.update(orderDoc, {'inCartIds': inCartIds});

      final itemDocId = '${orderId}_$itemRef';
      txn.delete(_orderItemCol.doc(itemDocId));
    });
  }

  // UPDATE CART ITEM
  @override
  Future<void> updateCartItem(String orderId, OrderItem item) async {
    final orderDoc = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snapshot = await txn.get(orderDoc);
      if (!snapshot.exists) throw Exception("Order not found");

      final data = snapshot.data()!;
      final inCartIds = List<String>.from(data['inCartIds'] ?? []);

      final itemRef = order_model.orderItemRef(item);

      final index = inCartIds.indexWhere((e) => e == itemRef);

      if (index != -1) {
        inCartIds[index] = itemRef;
      } else {
        inCartIds.add(itemRef);
      }

      txn.update(orderDoc, {'inCartIds': inCartIds});

      final itemDocId = '${orderId}_$itemRef';

      txn.set(
        _orderItemCol.doc(itemDocId),
        item.toJson()..['orderId'] = orderId,
      );
    });
  }

  // UPDATE ORDERED ITEM STATUS
  @override
  Future<void> updateOrderedItemStatus(
    String orderId,
    String menuItemId,
    OrderItemStatus status,
  ) async {
    final itemQuery = await _orderItemCol
        .where('orderId', isEqualTo: orderId)
        .where('menuItemId', isEqualTo: menuItemId)
        .get();

    for (final doc in itemQuery.docs) {
      await doc.reference.update({'orderItemStatus': status.name});
    }
  }

  // WATCH ALL ORDERS
  @override
  Stream<List<order_model.Order>> watchAllOrder() {
    return _orderCol.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => order_model.Order.fromJson(doc.data())).toList();
    });
  }

  // WATCH ORDER BY ID
  @override
  Stream<order_model.Order?> watchOrderById(String orderId) {
    return _orderCol.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return order_model.Order.fromJson(snapshot.data()!);
    });
  }

  // DELETE ORDER
  @override
  Future<void> delete(String orderId) async {
    final orderDoc = _orderCol.doc(orderId);

    // Delete order and related items
    await fireStore.runTransaction((txn) async {
      txn.delete(orderDoc);

      final itemsQuery = await _orderItemCol
          .where('orderId', isEqualTo: orderId)
          .get();
      for (final doc in itemsQuery.docs) {
        txn.delete(doc.reference);
      }
    });
  }
  
  @override
  Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  
  @override
  Future<order_model.Order?> getOrderById(String orderId) async {
    try {
      final doc = await fireStore.collection('orders').doc(orderId).get();
      if (!doc.exists) return null;
      return order_model.Order.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting order: $e');
      rethrow;
    }
  }
  
  @override
  Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)> getSearchOrders(String query, int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) {
    // TODO: implement getSearchOrders
    throw UnimplementedError();
  }
  
  @override
  Future<void> removeOrderedItem(String orderId, String menuItemId) {
    // TODO: implement removeOrderedItem
    throw UnimplementedError();
  }
  
  @override
  Future<order_model.Order> update(order_model.Order order) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
   @override
  Stream<order_model.Order?> watchCurrentOrder(String orderId) {
    return _orderCol.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final order = order_model.Order.fromJson(snapshot.data()!);
      _currentOrder = order;
      return order;
    });
  }
    
}
