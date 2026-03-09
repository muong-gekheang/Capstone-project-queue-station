import 'dart:async';

import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/services/user_provider.dart';

class TableService {
  final QueueTableRepository _queueTableRepository;
  final TableCategoryRepository _tableCategoryRepository;
  final UserProvider _userProvider;

  final StreamController<List<QueueTable>> _queueTableController =
      StreamController<List<QueueTable>>.broadcast();

  StreamSubscription<List<QueueTable>>? _queueTableSubscription;

  final StreamController<List<TableCategory>> _tableCategoryController =
      StreamController<List<TableCategory>>.broadcast();

  StreamSubscription<List<TableCategory>>? _tableCategorySubscription;

  TableService({
    required QueueTableRepository queueTableRepository,
    required UserProvider userProvider,
    required TableCategoryRepository tableCategoryRepository,
  }) : _queueTableRepository = queueTableRepository,
       _userProvider = userProvider,
       _tableCategoryRepository = tableCategoryRepository {
    _initStream();
  }

  String get _restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<QueueTable>> get streamQueueTable => _queueTableController.stream;

  Stream<List<TableCategory>> get streamTableCategories =>
      _tableCategoryController.stream;

  void _initStream() {
    if (_restId.isNotEmpty) {
      _queueTableSubscription = _queueTableRepository
          .watchAllQueueTable(_restId)
          .listen((data) {
            _queueTableController.add(data);
            _tables = data;
          }, onError: (error) => _queueTableController.addError(error));

      _tableCategorySubscription = _tableCategoryRepository
          .watchAllCategory(_restId)
          .listen((data) {
            _tableCategoryController.add(data);
            _tableCategories = data;
          }, onError: (error) => _queueTableController.addError(error));
    }
  }

  void dispose() {
    _queueTableController.close();
    _tableCategoryController.close();

    _tableCategorySubscription?.cancel();
    _queueTableSubscription?.cancel();
  }

  void addTable(QueueTable newTable) {
    _queueTableRepository.create(newTable);
  }

  void updateTable(QueueTable newTable) {
    _queueTableRepository.update(newTable);
  }

  void deleteTable(QueueTable table) {
    _queueTableRepository.delete(table.id);
  }

  void addTableCategory(TableCategory newCategory) {
    _tableCategoryRepository.create(newCategory);
  }

  void updateTableCategory(TableCategory newCategory) {
    _tableCategoryRepository.update(newCategory);
  }

  void deleteTableCategory(TableCategory tableCategory) {
    _tableCategoryRepository.delete(tableCategory.id);
  }

  // For Service-to-Service operation
  List<QueueTable> _tables = [];

  List<TableCategory> _tableCategories = [];
}
