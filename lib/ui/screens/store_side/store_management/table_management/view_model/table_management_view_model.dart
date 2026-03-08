import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/services/store/table_service.dart';

class TableManagementViewModel extends ChangeNotifier {
  final TableService _tableService;
  bool _isDisposed = false;
  bool _isLoading = true;
  List<QueueTable> _tables = [];

  StreamSubscription<List<QueueTable>>? _queueTableSubscription;

  TableManagementViewModel({required TableService tableService})
    : _tableService = tableService {
    _subscribeToQueueTable();
  }

  void _subscribeToQueueTable() {
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
  }

  bool get isLoading => _isLoading;

  List<QueueTable> get allTables => _tables;

  @override
  void dispose() {
    _queueTableSubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }
}
