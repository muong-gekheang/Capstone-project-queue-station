import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';

class QueueService {
  final UserProvider _userProvider;
  final QueueEntryRepository _queueEntryRepository;

  QueueService({
    required UserProvider userProvider,
    required QueueEntryRepository queueEntryRepository,
  }) : _userProvider = userProvider,
       _queueEntryRepository = queueEntryRepository;

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  // Queue Entry Operations
  Stream<List<QueueEntry>> get streamQueueEntries {
    return _queueEntryRepository.watchCurrentActiveQueue(_restId);
  }

  void addCustomerToQueue({required QueueEntry newQueue}) async {
    _queueEntryRepository.create(newQueue);
  }

  void serveCustomer(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.serving);
  }

  void removeUserFromQueue(String queueEntryId) {
    _queueEntryRepository.updateStatus(queueEntryId, QueueStatus.noShow);
  }
}
