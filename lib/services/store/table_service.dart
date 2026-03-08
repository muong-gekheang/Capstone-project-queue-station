import 'dart:async';

import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/services/user_provider.dart';

class TableService {
  final QueueTableRepository _queueTableRepository;
  final UserProvider _userProvider;

  final StreamController<List<QueueTable>> _controller =
      StreamController<List<QueueTable>>.broadcast();

  StreamSubscription<List<QueueTable>>? _queueTableSubscription;

  TableService({
    required QueueTableRepository queueTableRepository,
    required UserProvider userProvider,
  }) : _queueTableRepository = queueTableRepository,
       _userProvider = userProvider {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<QueueTable>> get streamQueueTable => _controller.stream;

  void _initStream() {
    if (_restId.isNotEmpty) {
      _queueTableSubscription = _queueTableRepository
          .watchAllQueueTable(_restId)
          .listen((data) {
            _controller.add(data);
            _tables = data;
          }, onError: (error) => _controller.addError(error));
    }
  }

  void dispose() {
    _controller.close();
    _queueTableSubscription?.cancel();
  }

  // For Service-to-Service operation
  List<QueueTable> _tables = [];
}
