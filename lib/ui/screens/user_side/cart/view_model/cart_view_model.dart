import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';

class CartViewModel extends ChangeNotifier {
  final OrderProvider orderProvider;
  final UserProvider userProvider;
  final QueueEntryRepository queueEntryRepository;

  CartViewModel({
    required this.orderProvider,
    required this.userProvider,
    required this.queueEntryRepository,
  }) {
    // Fetch queue details on initialization
    _fetchQueueDetails();
  }

  QueueEntry? _currentQueue;
  QueueEntry? get currentQueue => _currentQueue;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Cart (unconfirmed)
  List<OrderItem> get items => orderProvider.items;

  // Confirmed orders
  List<OrderItem> get confirmedItems =>
      List.unmodifiable(orderProvider.currentOrder.ordered);

  double get totalAmount => orderProvider.totalAmount;

  // Null-safe tableNumber
  String get tableNumber => _currentQueue?.tableNumber ?? "--";

  // Null-safe startTime
  String get startTime {
    final date = _currentQueue?.servedTime;
    if (date == null) return "--:--";

    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? "PM" : "AM";
    return "$hour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _fetchQueueDetails() async {
    final queueId = userProvider.asCustomer?.currentHistoryId;

    if (queueId != null) {
      _isLoading = true;
      notifyListeners();

      try {
        _currentQueue = await queueEntryRepository.getQueueEntryById(queueId);
      } catch (e) {
        debugPrint("Error fetching queue: $e");
        _currentQueue = null; // ensure null if fetch fails
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void confirmOrder(BuildContext context) {
    orderProvider.confirmCurrentOrder();
    Navigator.pop(context);
  }

  void removeItem(OrderItem item) {
    orderProvider.removeItem(item);
  }

  void increaseItem(OrderItem item) {
    orderProvider.updateCartItem(
      item,
      item.copyWith(quantity: item.quantity + 1),
    );
  }

  void decreaseItem(OrderItem item) {
    if (item.quantity > 1) {
      orderProvider.updateCartItem(
        item,
        item.copyWith(quantity: item.quantity - 1),
      );
    }
  }
}
