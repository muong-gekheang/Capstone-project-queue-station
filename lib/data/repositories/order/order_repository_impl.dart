import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
import 'package:queue_station_app/models/order/order_item.dart';

class OrderRepositoryImpl extends OrderRepository {
  final FirebaseFirestore fireStore;

  OrderRepositoryImpl({FirebaseFirestore? fireStore})
    : fireStore = fireStore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orderCol =>
      fireStore.collection('orders');

  CollectionReference<Map<String, dynamic>> get _orderItemCol =>
      fireStore.collection('order_items');

  Order? _currentOrder;

  Order get currentOrder => _currentOrder ??= Order.empty();

  // Helper method to safely convert document to Order
  // Helper method to safely convert document to Order
  Order? _orderFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      if (data == null) {
        print('❌ Document ${doc.id} has null data');
        return null;
      }

      // Log ALL fields to see what's actually in the document
      print('📄 Document ID: ${doc.id}');
      print('📄 Fields in document:');
      data.forEach((key, value) {
        print('   - $key: $value (${value.runtimeType})');
      });

      // Create a safe copy with the document ID
      final safeData = Map<String, dynamic>.from(data);

      // CRITICAL: Ensure id field exists
      if (safeData['id'] == null || safeData['id'].toString().isEmpty) {
        print('⚠️ Order ${doc.id} is missing id field, using document ID');
        safeData['id'] = doc.id;
        print('   Added id: ${safeData['id']}');
      } else {
        print('✅ id field exists: ${safeData['id']}');
      }

      // Check timestamp
      if (safeData['timestamp'] == null) {
        print('⚠️ Timestamp is missing, adding current time');
        safeData['timestamp'] = DateTime.now().toIso8601String();
      } else {
        print('✅ timestamp exists: ${safeData['timestamp']}');
      }

      print('🔄 Attempting to parse Order with safeData: $safeData');
      final order = Order.fromJson(safeData);
      print('✅ Order parsed successfully: ${order.id}');

      return order;
    } catch (e, stackTrace) {
      print('❌ Error converting order ${doc.id}: $e');
      print('Stack trace: $stackTrace');
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
          _orderItemCol.doc(itemDocId),
          item.toJson()..['orderId'] = order.id,
        );
      }

      for (final item in order.ordered) {
        final itemDocId = '${order.id}_${Order.orderItemRef(item)}';
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
    required Order order,
  }) async {
    if (order.inCart.isEmpty && order.id.isEmpty) return null;

    String? createdOrderId;

    await fireStore.runTransaction((transaction) async {
      String targetOrderId = order.id;
      final queueRef = fireStore.collection('queue_entries').doc(queueEntryId);

      if (targetOrderId.isEmpty) {
        final newOrderRef = _orderCol.doc();
        targetOrderId = newOrderRef.id;

        createdOrderId = targetOrderId;

        transaction.update(queueRef, {'orderId': targetOrderId});

        // ✅ Include id field when creating
        transaction.set(newOrderRef, {
          'id': targetOrderId, // CRITICAL: Include the id field
          'timestamp': DateTime.now().toIso8601String(),
          'restaurantId': order.restaurantId,
          'inCartIds': order.inCart.map(Order.orderItemRef).toList(),
          'orderedIds': [],
        });
      } else {
        final orderRef = _orderCol.doc(targetOrderId);

        // ✅ Ensure id is preserved when updating
        transaction.update(orderRef, {
          'id': targetOrderId, // CRITICAL: Keep the id field
          'inCartIds': order.inCart.map(Order.orderItemRef).toList(),
        });
      }

      for (final item in order.inCart) {
        final itemDocId = '${targetOrderId}_${Order.orderItemRef(item)}';

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

      transaction.update(orderRef, {
        'id': orderId, // ✅ Preserve id field
        'inCartIds': [],
        'orderedIds': [...currentOrdered, ...currentInCart],
        'lastConfirmedAt': DateTime.now().toIso8601String(),
      });

      for (String itemRef in currentInCart) {
        final itemDocRef = _orderItemCol.doc('${orderId}_$itemRef');
        transaction.update(itemDocRef, {
          'status': 'ordered',
          'confirmedAt': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  @override
  Future<OrderItem?> getOrderItemById(String orderId, String orderedId) async {
    final docId = '${orderId}_$orderedId';
    final doc = await _orderItemCol.doc(docId).get();

    if (!doc.exists) return null;
    doc.data()!['id'] = docId;

    return OrderItem.fromJson(doc.data()!);
  }

  @override
  Future<void> addItemToCart(String orderId, OrderItem item) async {
    final orderDoc = _orderCol.doc(orderId);

    await fireStore.runTransaction((txn) async {
      final snapshot = await txn.get(orderDoc);
      if (!snapshot.exists) throw Exception("Order not found");

      final data = snapshot.data()!;
      final inCartIds = List<String>.from(data['inCartIds'] ?? []);

      final itemRef = Order.orderItemRef(item);
      inCartIds.add(itemRef);

      txn.update(orderDoc, {
        'id': orderId, // ✅ Preserve id field
        'inCartIds': inCartIds,
      });

      final itemDocId = '${orderId}_$itemRef';
      txn.set(
        _orderItemCol.doc(itemDocId),
        item.toJson()..['orderId'] = orderId,
      );
    });
  }

  @override
  Stream<List<Order>> watchAllOrder() {
    return _orderCol.snapshots().map((snapshot) {
      final orders = <Order>[];
      for (final doc in snapshot.docs) {
        final order = _orderFromDoc(doc);
        if (order != null) {
          orders.add(order);
        }
      }
      return orders;
    });
  }

  @override
  Stream<Order?> watchOrderById(String orderId) {
    return _orderCol.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return _orderFromDoc(snapshot);
    });
  }

  @override
  Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _orderCol.doc(orderId).get();
      if (!doc.exists) {
        print('Order not found: $orderId');
        return null;
      }
      return _orderFromDoc(doc);
    } catch (e) {
      print('Error getting order $orderId: $e');
      return null;
    }
  }

  @override
  Stream<Order?> watchCurrentOrder(String orderId) {
    return _orderCol.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final order = _orderFromDoc(snapshot);
      if (order != null) {
        _currentOrder = order;
      }
      return order;
    });
  }

  @override
  Stream<List<Order>> watchTodayOrders(String restId) {
    final startOfToday = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    return fireStore
        .collection('orders')
        .where(
          'restaurantId',
          isEqualTo: restId,
        ) // Fixed: was 'restId', should be 'restaurantId'
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: startOfToday.toIso8601String(),
        ) // Fixed: use string for query
        .snapshots()
        .map((snapshot) {
          final orders = <Order>[];
          for (final doc in snapshot.docs) {
            final order = _orderFromDoc(doc);
            if (order != null) {
              orders.add(order);
            }
          }
          return orders;
        });
  }

  @override
  Future<void> delete(String orderId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<(List<Order>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchOrders(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getSearchOrders
    throw UnimplementedError();
  }

  @override
  Future<void> moveItemToOrdered(String orderId, OrderItem item) {
    // TODO: implement moveItemToOrdered
    throw UnimplementedError();
  }

  @override
  Future<void> removeItemFromCart(String orderId, OrderItem item) {
    // TODO: implement removeItemFromCart
    throw UnimplementedError();
  }

  @override
  Future<void> removeOrderedItem(String orderId, String menuItemId) {
    // TODO: implement removeOrderedItem
    throw UnimplementedError();
  }

  @override
  Future<Order> update(Order order) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> updateCartItem(String orderId, OrderItem item) {
    // TODO: implement updateCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrderedItemStatus(
    String orderId,
    String menuItemId,
    OrderItemStatus status,
  ) {
    // TODO: implement updateOrderedItemStatus
    throw UnimplementedError();
  }
}
