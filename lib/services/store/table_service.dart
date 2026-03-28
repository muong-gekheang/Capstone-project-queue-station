import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository.dart';
import 'package:queue_station_app/data/repositories/table_category/table_category_repository.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:rxdart/subjects.dart';

class TableService {
  final QueueTableRepository _queueTableRepository;
  final TableCategoryRepository _tableCategoryRepository;
  UserProvider _userProvider;

  final _queueTableController = BehaviorSubject<List<QueueTable>>.seeded([]);

  StreamSubscription<List<QueueTable>>? _queueTableSubscription;

  final _tableCategoryController = BehaviorSubject<List<TableCategory>>.seeded(
    [],
  );

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

  String get restId => _userProvider.asStoreUser?.restaurantId ?? "";

  Stream<List<QueueTable>> get streamQueueTable => _queueTableController.stream;

  Stream<List<TableCategory>> get streamTableCategories =>
      _tableCategoryController.stream;

  void _initStream() {
    if (restId.isNotEmpty) {
      _queueTableSubscription = _queueTableRepository
          .watchAllQueueTable(restId)
          .listen((data) {
            debugPrint("0: ${data.length}");
            _queueTableController.add(data);
            _tables = data;
          }, onError: (error) => _queueTableController.addError(error));

      _tableCategorySubscription = _tableCategoryRepository
          .watchAllCategory(restId)
          .listen(
            (data) {
              debugPrint("Stream cat service $data");
              _tableCategoryController.add(data);
              _tableCategories = data;
            },
            onError: (error) {
              _queueTableController.addError(error);
            },
          );
    }
  }

  String? _lastRestId;

  void updateDependencies(UserProvider newUserProvider) {
    _userProvider = newUserProvider;
    if (restId.isNotEmpty && restId != _lastRestId) {
      _lastRestId = restId; // Update the tracker
      _queueTableSubscription?.cancel();
      _tableCategorySubscription?.cancel();
      _initStream();
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

  void updateTableCustomers(QueueTable table, String queueEntryId) {
    _queueTableRepository.addCustomerToTable(table, queueEntryId);
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
  List<QueueTable> get tables => _tables;

  List<TableCategory> _tableCategories = [];
  List<TableCategory> get tableCategories => _tableCategories;
}
