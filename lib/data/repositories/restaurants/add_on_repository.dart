import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';

abstract class AddOnRepository {
  Future<void> create(AddOn addon);
  Future<void> delete(String addOnId);
  Future<AddOn> update(AddOn addon);
  Future<AddOn?> getAddOnById(String addOnId);
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)>
  getSearchAddOns(
    String query,
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<(List<AddOn>, DocumentSnapshot<Map<String, dynamic>>?)> getAll(
    int limit,
    DocumentSnapshot<Map<String, dynamic>>? lastDoc,
  );
  Future<void> deleteMany(List<String> ids);
  Future<List<AddOn>> getManyAddOnsById(List<String> ids);
  Stream<AddOn> watchCurrentAddOn();
  Stream<List<AddOn>> watchAllAddOn();
}
