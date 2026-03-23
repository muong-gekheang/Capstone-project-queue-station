import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class QueueProvider extends ChangeNotifier {
  final UserProvider userProvider;
  final QueueEntryRepository queueEntryRepository;

  QueueEntry? _currentQueueEntry;
  QueueEntry? get currentQueueEntry => _currentQueueEntry;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  QueueProvider({
    required this.userProvider,
    required this.queueEntryRepository,
  }) {
    // Listen to user changes
    userProvider.addListener(_onUserChanged);
  }

  void _onUserChanged() {
    refreshQueueStatus();
  }

  Future<void> refreshQueueStatus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final customer = userProvider.asCustomer;

    if (customer == null || customer.currentHistoryId == null) {
      _currentQueueEntry = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _currentQueueEntry = await queueEntryRepository.getQueueEntryById(
        customer.currentHistoryId!,
      );
    } catch (e) {
      debugPrint("Error refreshing queue: $e");
      _error = e.toString();
      _currentQueueEntry = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  bool get canAccessMenu {
    if (_currentQueueEntry == null) return false;
    final status = _currentQueueEntry!.status.name.trim().toLowerCase();
    return status == 'serving';
  }

  String? get queueNumber => _currentQueueEntry?.queueNumber?.toString();

  @override
  void dispose() {
    userProvider.removeListener(_onUserChanged);
    super.dispose();
  }
}
