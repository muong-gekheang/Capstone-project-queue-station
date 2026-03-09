import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/services/store/table_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management/widgets/table_management_content.dart';

class TableManagementViewModel extends ChangeNotifier {
  final TableService _tableService;
  bool _isDisposed = false;
  bool _isLoading = true;
  List<QueueTable> _tables = [];
  List<TableCategory> _tableCategories = [];
  TableCategory? currentSelectedCategory;
  bool isEditMode = false;
  String searchQuery = "";

  FilterOption currentFilter = FilterOption.clear;

  StreamSubscription<List<QueueTable>>? _queueTableSubscription;
  StreamSubscription<List<TableCategory>>? _tableCategorySubscription;

  TableManagementViewModel({required TableService tableService})
    : _tableService = tableService {
    _subscribe();
    if (_tableCategories.isNotEmpty) {
      currentSelectedCategory = _tableCategories.first;
    }
  }

  void _subscribe() {
    _queueTableSubscription = _tableService.streamQueueTable.listen(
      (tables) {
        if (_isDisposed) return;
        _tables = tables;
        _isLoading = false;
        notifyListeners(); // Updates the UI
      },
      onError: (error) {
        if (_isDisposed) return;
        // Handle potential stream errors here
        _isLoading = false;
        notifyListeners();
      },
    );

    _tableCategorySubscription = _tableService.streamTableCategories.listen(
      (categories) {
        if (_isDisposed) return;
        _tableCategories = categories;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void updateCurrentSelectedCategory(TableCategory cat) {
    currentSelectedCategory = cat;
    notifyListeners();
  }

  void updateIsEditMode(bool isEdit) {
    isEditMode = isEdit;
    notifyListeners();
  }

  void setFilter(FilterOption option) {
    currentFilter = option;
    notifyListeners();
  }

  void addNewTable(QueueTable newTable) {
    _tableService.addTable(newTable);
  }

  void updateTable(QueueTable newTable) {
    _tableService.updateTable(newTable);
  }

  void deleteTable(QueueTable table) {
    _tableService.deleteTable(table);
  }

  void addNewCategory(TableCategory newCategory) {
    _tableService.addTableCategory(newCategory);
  }

  void updateTableCategory(TableCategory newCategory) {
    _tableService.updateTableCategory(newCategory);
  }

  void deleteTableCategory(TableCategory tableCategory) {
    _tableService.deleteTableCategory(tableCategory);
  }

  void onSearch(String keyword) {
    searchQuery = keyword;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  bool get isFiltered => currentFilter != FilterOption.clear;

  List<TableCategory> get tableCategories => _tableCategories;

  List<QueueTable> get allTables => _tables;

  List<QueueTable> get filteredTable {
    List<QueueTable> result = [];
    // 1. Filter by the selected Category
    if (currentSelectedCategory != null) {
      result = allTables
          .where(
            (t) =>
                findTableCatById(t.tableCategoryId).id ==
                currentSelectedCategory!.id,
          )
          .toList();
    }

    // 2. Filter by Search Query
    if (searchQuery.isNotEmpty) {
      result = result
          .where(
            (t) => t.tableNum.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // 3. Filter by Status
    if (isFiltered && currentFilter != FilterOption.clear) {
      result = result.where((t) {
        if (currentFilter == FilterOption.available) {
          return t.tableStatus == TableStatus.available;
        } else if (currentFilter == FilterOption.occupied) {
          return t.tableStatus == TableStatus.occupied;
        }
        return true;
      }).toList();
    }

    return result;
  }

  TableCategory findTableCatById(String id) {
    return _tableCategories.firstWhere((e) => e.id == id);
  }

  @override
  void dispose() {
    _queueTableSubscription?.cancel();
    _tableCategorySubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }
}
