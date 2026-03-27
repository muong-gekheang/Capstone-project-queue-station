import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/order/order.dart';
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

  CartViewModel({
    required this.orderProvider,
    required this.userProvider,
    required this.queueEntryRepository,
    required this.userRepository,
  }) {
    _init();
    // ✅ Add listener to update UI when order changes
    orderProvider.addListener(_onOrderProviderChanged);
  }

  Order? _detailedOrder; // Stores the order with MenuItem details
  QueueEntry? _currentQueue;
  bool _isLoading = false;
  bool _isDisposed = false;

  // ---------------------------
  // Getters
  // ---------------------------
  bool get isLoading => _isLoading;
  QueueEntry? get currentQueue => _currentQueue;

  /// Returns items with full details if available, otherwise falls back to provider items
  List<OrderItem> get items => _detailedOrder?.inCart ?? orderProvider.items;

  /// Returns confirmed items already sent to the kitchen
  List<OrderItem> get confirmedItems =>
      _detailedOrder?.ordered ?? (orderProvider.currentOrder?.ordered ?? []);

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

  // ---------------------------
  // Initialization & Sync
  // ---------------------------

  Future<void> _init() async {
    final queueId = userProvider.asCustomer?.currentHistoryId;
    if (queueId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Fetch details and queue info in parallel for speed
      final results = await Future.wait([
        orderProvider.currentOrderInDetails,
        queueEntryRepository.getQueueEntryById(queueId),
      ]);

      _detailedOrder = results[0] as Order?;
      _currentQueue = results[1] as QueueEntry?;
    } catch (e) {
      debugPrint("Error fetching cart details: $e");
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// When OrderProvider updates (optimistic update), we re-fetch the details
  /// to ensure the UI has the MenuItem objects for names/images.
  void _onOrderProviderChanged() async {
    if (_isDisposed) return;

    final updatedDetails = await orderProvider.currentOrderInDetails;

    if (!_isDisposed) {
      _detailedOrder = updatedDetails;
      notifyListeners();
    }
  }

  // ---------------------------
  // Cart Actions
  // ---------------------------

  Future<void> increaseItem(OrderItem item) async {
    try {
      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      await orderProvider.updateCart(updatedItem);
    } catch (e) {
      debugPrint('Error increasing item: $e');
    }
  }

  Future<void> decreaseItem(OrderItem item) async {
    try {
      if (item.quantity > 1) {
        final updatedItem = item.copyWith(quantity: item.quantity - 1);
        await orderProvider.updateCart(updatedItem);
      } else {
        await removeItem(item);
      }
    } catch (e) {
      debugPrint('Error decreasing item: $e');
    }
  }

  Future<void> removeItem(OrderItem item) async {
    try {
      await orderProvider.removeItem(item);
    } catch (e) {
      debugPrint('Error removing item: $e');
    }
  }

  Future<void> editItem(OrderItem oldItem, OrderItem newItem) async {
    try {
      // Perform both actions; the debouncer in OrderProvider will handle the sync
      await orderProvider.removeItem(oldItem);
      await orderProvider.addToCart(newItem);
    } catch (e) {
      debugPrint('Error editing item: $e');
    }
  }

  /// Confirms the current 'inCart' items and moves them to 'ordered'
  Future<void> confirmOrder(BuildContext context) async {
    final currentOrderSnapshot = orderProvider.currentOrder;
    if (currentOrderSnapshot == null || items.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Prepare the updated ordered list
      final updatedOrdered = List<OrderItem>.from(currentOrderSnapshot.ordered)
        ..addAll(items);

      // 2. Create the confirmed state
      final confirmedOrder = currentOrderSnapshot.copyWith(
        inCart: [],
        ordered: updatedOrdered,
      );

      // 3. Save directly to service to ensure the order is placed
      await orderProvider.orderService.saveOrder(confirmedOrder);

      // 4. Clear the optimistic cart in the provider
      await orderProvider.clearCart();

      // 5. Refresh local details to reflect empty cart
      _detailedOrder = await orderProvider.currentOrderInDetails;

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

  // ---------------------------
  // Session Actions
  // ---------------------------

  Future<void> checkout() async {
    if (_currentQueue == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Update Queue Status
      await queueEntryRepository.update(
        _currentQueue!.copyWith(status: QueueStatus.completed),
      );

      // Update Local User State
      final updatedUser = userProvider.asCustomer!.copyWith(
        currentHistoryId: null,
      );
      userProvider.updateUser(updatedUser);

      // Sync User to Repository
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
    orderProvider.removeListener(_onOrderProviderChanged);
    super.dispose();
  }
}
