import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';

class AddOnRepositoryMock implements AddOnRepository {
  Map<String, AddOn> addOns = {};

  AddOnRepositoryMock() {
     for (var addOn in globalAddOns) { 
      addOns[addOn.id] = addOn;
    }
  }

  @override
  Future<void> create(AddOn addon) => throw UnimplementedError();
  @override
  Future<void> delete(String addOnId) => throw UnimplementedError();
  @override
  Future<void> deleteMany(List<String> ids) => throw UnimplementedError();
  @override
  Future<AddOn?> getAddOnById(String addOnId) async => addOns[addOnId];
  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getAddOnsByMenuItemId(
    String menuItemId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) => throw UnimplementedError();
  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) => throw UnimplementedError();
  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getSearchAddOns(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) => throw UnimplementedError();
  @override
  Future<AddOn> update(AddOn addon) => throw UnimplementedError();
  @override
  @override
  Stream<List<AddOn>> watchAllAddOn(String restId) {
    // TODO: implement watchAllAddOn
    throw UnimplementedError();
  }

  @override
  Stream<AddOn> watchCurrentAddOn(String addOnId) => throw UnimplementedError();
}