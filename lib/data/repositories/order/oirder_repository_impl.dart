// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:queue_station_app/data/repositories/order/order_repository.dart';
// import 'package:queue_station_app/models/order/order.dart'
//     as order_model
//     show Order, OrderItem, orderItemRef;
// import 'package:queue_station_app/models/order/order_item.dart';

// class OrderRepositoryImpl extends OrderRepository {
//   final FirebaseFirestore fireStore;

//   OrderRepositoryImpl({FirebaseFirestore? fireStore})
//     : fireStore = fireStore ?? FirebaseFirestore.instance;

//   CollectionReference<Map<String, dynamic>> get _orderCol =>
//       fireStore.collection('orders');

//   CollectionReference<Map<String, dynamic>> get _orderItemCol =>
//       fireStore.collection('order_items');

//   order_model.Order? _currentOrder;
//   order_model.Order get currentOrder =>
//       _currentOrder ??= order_model.Order.empty();

//   // CREATE ORDER
//   @override
//   Future<void> create(order_model.Order order) async {
//     final orderRef = _orderCol.doc(order.id);

//     await fireStore.runTransaction((txn) async {
//       // Save the order itself (IDs only)
//       txn.set(orderRef, {
//         'id': order.id,
//         'timestamp': order.timestamp.toIso8601String(),
//         'inCartIds': order.inCart.map(order_model.orderItemRef).toList(),
//         'orderedIds': order.ordered.map(order_model.orderItemRef).toList(),
//       });

//       // Save each inCart item
//       for (final item in order.inCart) {
//         final itemDocId = '${order.id}_${order_model.orderItemRef(item)}';
//         txn.set(
//           _orderItemCol.doc(itemDocId),
//           item.toJson()..['orderId'] = order.id,
//         );
//       }

//       // Save each ordered item
//       for (final item in order.ordered) {
//         final itemDocId = '${order.id}_${order_model.orderItemRef(item)}';
//         txn.set(
//           _orderItemCol.doc(itemDocId),
//           item.toJson()..['orderId'] = order.id,
//         );
//       }
//     });
//   }

//   // ADD ITEM TO CART
//   @override
//   Future<void> addItemToCart(String orderId, OrderItem item) async {
//     final orderDoc = _orderCol.doc(orderId);

//     await fireStore.runTransaction((txn) async {
//       final snapshot = await txn.get(orderDoc);
//       if (!snapshot.exists) throw Exception("Order not found");

//       final data = snapshot.data()!;
//       final inCartIds = List<String>.from(data['inCartIds'] ?? []);
//       inCartIds.add(order_model.orderItemRef(item));

//       txn.update(orderDoc, {'inCartIds': inCartIds});

//       // Save item in order_items collection
//       final itemDocId = '${orderId}_${order_model.orderItemRef(item)}';
//       txn.set(
//         _orderItemCol.doc(itemDocId),
//         item.toJson()..['orderId'] = orderId,
//       );
//     });
//   }

//   // MOVE ITEM FROM CART TO ORDERED
//   @override
//   Future<void> moveItemToOrdered(String orderId, String menuItemId) async {
//     final orderDoc = _orderCol.doc(orderId);

//     await fireStore.runTransaction((txn) async {
//       final snapshot = await txn.get(orderDoc);
//       if (!snapshot.exists) throw Exception("Order not found");

//       final data = snapshot.data()!;
//       final inCartIds = List<String>.from(data['inCartIds'] ?? []);
//       final orderedIds = List<String>.from(data['orderedIds'] ?? []);

//       final index = inCartIds.indexWhere((e) => e.startsWith(menuItemId));
//       if (index != -1) {
//         final itemRefStr = inCartIds.removeAt(index);
//         orderedIds.add(itemRefStr);

//         txn.update(orderDoc, {
//           'inCartIds': inCartIds,
//           'orderedIds': orderedIds,
//         });

//         // Update order_items status
//         final itemDoc = _orderItemCol.doc('${orderId}_$itemRefStr');
//         txn.update(itemDoc, {'orderItemStatus': 'accepted'});
//       }
//     });
//   }

//   // REMOVE ITEM FROM CART
//   @override
//   Future<void> removeItemFromCart(String orderId, String menuItemId) async {
//     final orderDoc = _orderCol.doc(orderId);

//     await fireStore.runTransaction((txn) async {
//       final snapshot = await txn.get(orderDoc);
//       if (!snapshot.exists) throw Exception("Order not found");

//       final data = snapshot.data()!;
//       final inCartIds = List<String>.from(data['inCartIds'] ?? []);
//       inCartIds.removeWhere((e) => e.startsWith(menuItemId));

//       txn.update(orderDoc, {'inCartIds': inCartIds});

//       // Delete item from order_items
//       final itemDocQuery = await _orderItemCol
//           .where('orderId', isEqualTo: orderId)
//           .where('menuItemId', isEqualTo: menuItemId)
//           .get();
//       for (final doc in itemDocQuery.docs) {
//         txn.delete(doc.reference);
//       }
//     });
//   }

//   // UPDATE CART ITEM
//   @override
//   Future<void> updateCartItem(String orderId, OrderItem item) async {
//     final orderDoc = _orderCol.doc(orderId);

//     await fireStore.runTransaction((txn) async {
//       final snapshot = await txn.get(orderDoc);
//       if (!snapshot.exists) throw Exception("Order not found");

//       final data = snapshot.data()!;
//       final inCartIds = List<String>.from(data['inCartIds'] ?? []);

//       // Remove old reference and add updated
//       inCartIds.removeWhere((e) => e.startsWith(item.menuItemId));
//       inCartIds.add(order_model.orderItemRef(item));

//       txn.update(orderDoc, {'inCartIds': inCartIds});

//       // Update order_items
//       final itemDocId = '${orderId}_${order_model.orderItemRef(item)}';
//       txn.set(
//         _orderItemCol.doc(itemDocId),
//         item.toJson()..['orderId'] = orderId,
//       );
//     });
//   }

//   // UPDATE ORDERED ITEM STATUS
//   @override
//   Future<void> updateOrderedItemStatus(
//     String orderId,
//     String menuItemId,
//     OrderItemStatus status,
//   ) async {
//     final itemQuery = await _orderItemCol
//         .where('orderId', isEqualTo: orderId)
//         .where('menuItemId', isEqualTo: menuItemId)
//         .get();

//     for (final doc in itemQuery.docs) {
//       await doc.reference.update({'orderItemStatus': status.name});
//     }
//   }

//   // WATCH ALL ORDERS
//   @override
//   Stream<List<order_model.Order>> watchAllOrder() {
//     return _orderCol.snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => order_model.Order.fromJson(doc.data()))
//           .toList();
//     });
//   }

//   // WATCH ORDER BY ID
//   @override
//   Stream<order_model.Order?> watchOrderById(String orderId) {
//     return _orderCol.doc(orderId).snapshots().map((snapshot) {
//       if (!snapshot.exists) return null;
//       return order_model.Order.fromJson(snapshot.data()!);
//     });
//   }

//   // DELETE ORDER
//   @override
//   Future<void> delete(String orderId) async {
//     final orderDoc = _orderCol.doc(orderId);

//     // Delete order and related items
//     await fireStore.runTransaction((txn) async {
//       txn.delete(orderDoc);

//       final itemsQuery = await _orderItemCol
//           .where('orderId', isEqualTo: orderId)
//           .get();
//       for (final doc in itemsQuery.docs) {
//         txn.delete(doc.reference);
//       }
//     });
//   }

//   @override
//   Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)>
//   getAll(int limit, DocumentSnapshot<Map<String, dynamic>>? lastDoc) {
//     // TODO: implement getAll
//     throw UnimplementedError();
//   }

//   @override
//   Future<order_model.Order?> getOrderById(String orderId) {
//     // TODO: implement getOrderById
//     throw UnimplementedError();
//   }

//   @override
//   Future<(List<order_model.Order>, DocumentSnapshot<Map<String, dynamic>>?)>
//   getSearchOrders(
//     String query,
//     int limit,
//     DocumentSnapshot<Map<String, dynamic>>? lastDoc,
//   ) {
//     // TODO: implement getSearchOrders
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> removeOrderedItem(String orderId, String menuItemId) {
//     // TODO: implement removeOrderedItem
//     throw UnimplementedError();
//   }

//   @override
//   Future<order_model.Order> update(order_model.Order order) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }

//   @override
//   Stream<order_model.Order?> watchCurrentOrder(String orderId) {
//     return _orderCol.doc(orderId).snapshots().map((snapshot) {
//       if (!snapshot.exists) return null;
//       final order = order_model.Order.fromJson(snapshot.data()!);
//       _currentOrder = order;
//       return order;
//     });
//   }
// }
