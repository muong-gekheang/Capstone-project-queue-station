import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/menu/menu_size/menu_size_repository.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';

class MenuSizeRepositoryImpl implements MenuSizeRepository {
  final FirebaseFirestore firestore;

  MenuSizeRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;
  @override
  Future<void> create(MenuSize menuSize) async {
    final menuSizeRef = firestore.collection('sizes').doc(menuSize.id);
    await menuSizeRef.set(menuSize.toJson());
  }

  @override
  Future<void> delete(String menuSizeId) async {
    await firestore.collection('sizes').doc(menuSizeId).delete();
  }

  @override
  Future<void> update(MenuSize menuSize) async {
    final menuSizeRef = firestore.collection('sizes').doc(menuSize.id);
    await menuSizeRef.update(menuSize.toJson());
  }

  @override
  Future<MenuSize?> getMenuSizeById(String menuSizeId) async {
    try {
      final doc = await firestore.collection("sizes").doc(menuSizeId).get();
      final result = MenuSize.fromJson(doc.data()!);
      return result;
    } catch (err) {
      return null;
    }
  }
}
