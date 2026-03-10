import 'package:flutter/material.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
// import 'package:queue_station_app/services/queue_service.dart'; // Assume this exists

enum SortOption { oldest, newest }

class StoreQueueHistoryViewModel extends ChangeNotifier {
  // State variables
  int _selectedIndex = 0;
  String _searchQuery = '';
  SortOption? _selectedSortOption;

  // Getters
  int get selectedIndex => _selectedIndex;
  String get searchQuery => _searchQuery;
  SortOption? get selectedSortOption => _selectedSortOption;

  // Logic to update state and notify UI
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  /// This is where you will implement the filtering logic
  /// likely combining your search/tab/sort state with the stream from QueueService
  List<QueueEntry> getFilteredHistory(List<QueueEntry> rawEntries) {
    // Your implementation here using _searchQuery, _selectedIndex, etc.
    return [];
  }
}
