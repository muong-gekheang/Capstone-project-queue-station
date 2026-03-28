import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/services/user_provider.dart';

class CartViewModel extends ChangeNotifier {
  final OrderProvider orderProvider;
  final UserProvider userProvider;
  final QueueEntryRepository queueEntryRepository;
  final UserRepository<Customer> userRepository;

  QueueEntry? _currentQueue;
  bool _isLoading = false;
  bool _isDisposed = false;

  CartViewModel({
    required this.orderProvider,
    required this.userProvider,
    required this.queueEntryRepository,
    required this.userRepository,
  }) {
    _init();
    // ✅ ONLY listen for UI refresh, NOT for fetching details
    orderProvider.addListener(_onCartChanged);
  }

  bool get isLoading => _isLoading;

  // ✅ Use orderProvider.items directly - no delay!
  List<OrderItem> get items => orderProvider.items;

  List<OrderItem> get confirmedItems =>
      orderProvider.currentOrder?.ordered ?? [];

  double get totalAmount => orderProvider.totalAmount;

  String get tableNumber => _currentQueue?.tableNumber ?? "--";

  String get startTime {
    final date = _currentQueue?.servedTime;
    if (date == null) return "--:--";
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? "PM" : "AM";
    return "$hour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> _init() async {
    final queueId = userProvider.asCustomer?.currentHistoryId;
    if (queueId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // ✅ Only fetch queue info once
      _currentQueue = await queueEntryRepository.getQueueEntryById(queueId);
    } catch (e) {
      debugPrint("Error fetching queue: $e");
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // ✅ Just refresh UI, don't fetch from Firestore
  void _onCartChanged() {
    if (!_isDisposed) {
      notifyListeners(); // Simple UI refresh - instant!
    }
  }

  // Cart actions - these are already instant
  Future<void> increaseItem(OrderItem item) async {
    final updatedItem = item.copyWith(quantity: item.quantity + 1);
    await orderProvider.updateCart(updatedItem); // UI updates instantly
  }

  Future<void> decreaseItem(OrderItem item) async {
    if (item.quantity > 1) {
      final updatedItem = item.copyWith(quantity: item.quantity - 1);
      await orderProvider.updateCart(updatedItem);
    } else {
      await removeItem(item);
    }
  }

  Future<void> removeItem(OrderItem item) async {
    await orderProvider.removeItem(item);
  }

  Future<void> confirmOrder(BuildContext context) async {
    final currentOrderSnapshot = orderProvider.currentOrder;
    if (currentOrderSnapshot == null || items.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedOrdered = List<OrderItem>.from(currentOrderSnapshot.ordered)
        ..addAll(items);

      final confirmedOrder = currentOrderSnapshot.copyWith(
        inCart: [],
        ordered: updatedOrdered,
      );

      await orderProvider.orderService.saveOrder(confirmedOrder);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Order confirmed!")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to confirm: $e")));
      }
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> checkout() async {
    if (_currentQueue == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await queueEntryRepository.updateStatus(
        _currentQueue!.id,
        QueueStatus.completed,
      );

      final updatedUser = userProvider.asCustomer!.copyWith(
        currentHistoryId: null,
        noQueue: true,
      );
      userProvider.updateUser(updatedUser);
      await userRepository.update(updatedUser);
    } catch (err) {
      debugPrint("Checkout Error: $err");
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    orderProvider.removeListener(_onCartChanged);
    super.dispose();
  }
}
