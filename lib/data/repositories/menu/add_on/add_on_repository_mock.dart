import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/add_on/add_on_repository.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';

class AddOnRepositoryMock implements AddOnRepository {
  Map<String, AddOn> addOns = {};

  AddOnRepositoryMock() {
    for (var addOn in mockMenuAddOns) {
      addOns[addOn.id] = addOn;
    }
  }
  @override
  Future<void> create(AddOn addon) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String addOnId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(List<String> ids) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  Future<AddOn?> getAddOnById(String addOnId) async {
    return addOns[addOnId];
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)>
  getAddOnsByMenuItemId(
    String menuItemId,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAddOnsByMenuItemId
    throw UnimplementedError();
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchAddOns(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  ) {
    // TODO: implement getSearchAddOns
    throw UnimplementedError();
  }

  @override
  Future<AddOn> update(AddOn addon) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<AddOn>> watchAllAddOn() {
    // TODO: implement watchAllAddOn
    throw UnimplementedError();
  }

  @override
  Stream<AddOn> watchCurrentAddOn(String addOnId) {
    // TODO: implement watchCurrentAddOn
    throw UnimplementedError();
  }
}
