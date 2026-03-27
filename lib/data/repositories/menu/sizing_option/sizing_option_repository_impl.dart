import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/sizing_option/sizing_option_repository.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';

class SizingOptionRepositoryImpl implements SizingOptionRepository {
  final FirebaseFirestore firestore;

  SizingOptionRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;
  @override
  Future<void> create(SizeOption newSizeOption) async {
    final sizeOptionRef = firestore
        .collection('size_options')
        .doc(newSizeOption.id);
    final sizeOptionJson = Map<String, dynamic>.from(newSizeOption.toJson());
    await sizeOptionRef.set(sizeOptionJson);
  }

  @override
  Future<void> delete(String sizeOptionId) async {
    await firestore.collection('size_options').doc(sizeOptionId).delete();
  }

  @override
  Future<SizeOption?> getById(String sizeOptionId) async {
    try {
      final doc = await firestore
          .collection('size_options')
          .doc(sizeOptionId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final json = Map<String, dynamic>.from(doc.data()!);
      // Ensure the ID is present in the JSON for the model factory
      json['id'] ??= doc.id;

      return SizeOption.fromJson(json);
    } catch (e) {
      debugPrint("Error fetching SizeOption $sizeOptionId: $e");
      return null;
    }
  }

  @override
  Stream<List<SizeOption>> watchAllSizeOptions(String restaurantId) {
    return firestore
        .collection('size_options')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .handleError((err) => debugPrint("Retrieval Error: $err"))
        .map(
          (snap) => snap.docs.map((doc) {
            debugPrint("Retrieval: ${doc.data()}");
            final json = Map<String, dynamic>.from(doc.data());
            json['id'] ??= doc.id;
            return SizeOption.fromJson(json);
          }).toList(),
        );
  }
}
