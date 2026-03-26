import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queue_station_app/data/repositories/map/social/social_account_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant_social.dart';

class SocialAccountRepositoryImpl implements SocialAccountRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // The name of the new collection in Firebase
  final String _collectionPath = 'social_accounts';

  @override
  Future<List<SocialAccount>> getAccountsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    List<SocialAccount> accounts = [];

    try {
      for (var i = 0; i < ids.length; i += 10) {
        final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);

        final snapshot = await _firestore
            .collection(_collectionPath)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        accounts.addAll(
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Ensure the ID from Firebase is injected
            return SocialAccount.fromJson(data);
          }),
        );
      }
      return accounts;
    } catch (e) {
      print("Error fetching social accounts: $e");
      return [];
    }
  }

  @override
  Future<void> saveAccount(SocialAccount account) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(account.id)
          .set(account.toJson());
    } catch (e) {
      print("Error saving social account: $e");
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      print("Error deleting social account: $e");
    }
  }
}
