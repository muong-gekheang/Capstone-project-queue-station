import 'package:flutter/material.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';

enum SortOption { oldest, newest }

class StoreQueueHistoryViewModel extends ChangeNotifier {
  final QueueService _queueService;
  final OrderService _orderService;

  StoreQueueHistoryViewModel({
    required QueueService queueService,
    required OrderService orderService,
  }) : _queueService = queueService,
       _orderService = orderService {
    loadMore();
  }

  // State variables
  int _selectedIndex = 0;
  String _searchQuery = '';
  SortOption? _selectedSortOption;

  // Getters
  int get selectedIndex => _selectedIndex;
  String get searchQuery => _searchQuery;
  SortOption? get selectedSortOption => _selectedSortOption;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<QueueEntry> viewHistoryDetail(QueueEntry history) async {
    switch (history.joinedMethod) {
      case JoinedMethod.remote:
        return history.orderId != null
            ? history.remoteCopyWith(
                order: await _orderService.getOrderDetailsById(
                  history.orderId!,
                ),
              )
            : history;
      case JoinedMethod.walkIn:
        return history.orderId != null
            ? history.walkInCopyWith(
                order: await _orderService.getOrderDetailsById(
                  history.orderId!,
                ),
              )
            : history;
    }
  }

  bool _isFetching = false;
  bool _hasMoreData = true;

  bool get isFetching => _isFetching;
  bool get hasMoreData => _hasMoreData;

  Future<void> loadMore() async {
    if (_isFetching || !_hasMoreData) return; // Guard clauses

    _isFetching = true;
    notifyListeners();

    final success = await _queueService.retrieveNextQueueHistory();

    // If the repository returned fewer items than the limit, we hit the end
    if (success && _queueService.lastDoc == null) {
      _hasMoreData = false;
    }

    _isFetching = false;
    notifyListeners();
  }

  void setSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  List<QueueEntry> getFilteredHistory() {
    List<QueueEntry> results = List.from(_queueService.queueHistory);

    // 1. Filter by Search Query (Name)
    if (_searchQuery.isNotEmpty) {
      results = results.where((entry) {
        // Assuming you have a way to get the customer name from the entry
        // or from a local map of customers
        return entry.customerId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // 2. Filter by Date (Tabs)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    results = results.where((entry) {
      final entryDate = entry.joinTime;

      switch (_selectedIndex) {
        case 1: // Today
          return entryDate.isAfter(today);
        case 2: // Last 7 Days
          return entryDate.isAfter(now.subtract(const Duration(days: 7)));
        case 3: // This Month
          return entryDate.month == now.month && entryDate.year == now.year;
        case 0: // All
        default:
          return true;
      }
    }).toList();

    // 3. Apply Sorting
    if (_selectedSortOption == SortOption.newest) {
      results.sort((a, b) => b.joinTime.compareTo(a.joinTime));
    } else if (_selectedSortOption == SortOption.oldest) {
      results.sort((a, b) => a.joinTime.compareTo(b.joinTime));
    }
    debugPrint("Hist: ${results.length}");

    return results;
  }
}
