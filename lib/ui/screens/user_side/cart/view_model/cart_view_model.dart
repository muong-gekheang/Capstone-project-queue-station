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
    _fetchQueueDetails();
    // ✅ Add listener to update UI when order changes
    orderProvider.addListener(_onOrderProviderChanged);
  }

  void _onOrderProviderChanged() {
    notifyListeners();
  }

  QueueEntry? _currentQueue;
  QueueEntry? get currentQueue => _currentQueue;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Cart (unconfirmed items currently in the 'inCart' list)
  List<OrderItem> get items => orderProvider.items;

  // Confirmed orders (items already sent to the kitchen)
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

  Future<void> _fetchQueueDetails() async {
    final queueId = userProvider.asCustomer?.currentHistoryId;
    if (queueId != null) {
      _isLoading = true;
      notifyListeners();
      try {
        _currentQueue = await queueEntryRepository.getQueueEntryById(queueId);
      } catch (e) {
        debugPrint("Error fetching queue: $e");
        _currentQueue = null;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // ---------------------------
  // Actions (Fixed)
  // ---------------------------

  /// Increases quantity and syncs to Firestore
  Future<void> increaseItem(OrderItem item) async {
    try {
      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      await orderProvider.updateCart(updatedItem);
    } catch (e) {
      debugPrint('Error increasing item: $e');
    }
  }

  /// Decreases quantity (min 1) and syncs to Firestore
  Future<void> decreaseItem(OrderItem item) async {
    try {
      if (item.quantity > 1) {
        final updatedItem = item.copyWith(quantity: item.quantity - 1);
        await orderProvider.updateCart(updatedItem);
      } else {
        // Remove item if quantity is 1
        await removeItem(item);
      }
    } catch (e) {
      debugPrint('Error decreasing item: $e');
    }
  }

  /// Removes the item entirely from the cart
  Future<void> removeItem(OrderItem item) async {
    try {
      // ✅ Use await and let orderProvider handle the save
      await orderProvider.removeItem(item);
    } catch (e) {
      debugPrint('Error removing item: $e');
    }
  }

  /// Edit item (remove old, add new)
  Future<void> editItem(OrderItem oldItem, OrderItem newItem) async {
    try {
      // ✅ Make this async and let orderProvider handle saves
      await orderProvider.removeItem(oldItem);
      await orderProvider.addToCart(newItem);
    } catch (e) {
      debugPrint('Error editing item: $e');
    }
  }

  /// Confirms the current 'inCart' items and moves them to 'ordered'
  Future<void> confirmOrder(BuildContext context) async {
    if (orderProvider.currentOrder == null || items.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Move items from inCart to ordered
      final updatedOrdered = List<OrderItem>.from(
        orderProvider.currentOrder!.ordered,
      )..addAll(items);

      // Clear the cart and update ordered list
      final confirmedOrder = orderProvider.currentOrder!.copyWith(
        inCart: [],
        ordered: updatedOrdered,
      );

      // Save to Firestore
      await orderProvider.orderService.saveOrder(confirmedOrder);

      // Clear local cart state
      await orderProvider.clearCart();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order confirmed!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to confirm: $e")),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    //Clean up listener
    orderProvider.removeListener(_onOrderProviderChanged);
    super.dispose();
  }
}