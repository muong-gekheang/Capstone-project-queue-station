import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        await _firebaseAuth.signOut();
        throw Exception("This user account doesn't exist");
      }
      return credential.user;
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  @override
  Future<User?> register(Customer customer, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: customer.email,
        password: password,
      );

      final user = result.user;
      if (user == null) return null;

      final uid = user.uid;

      final customerWithUid = Customer(
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        id: uid,
        historyIds: customer.historyIds,
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(customerWithUid.toJson());

      return user;
    } catch (e) {
      print('Error registering admin: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
