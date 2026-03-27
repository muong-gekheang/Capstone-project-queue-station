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
      email = email.trim();
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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          debugPrint('No user found for that email.');
          break;
        case 'wrong-password':
          debugPrint('Wrong password provided.');
          break;
        case 'invalid-credential':
          debugPrint('Credential is malformed or expired.');
          break;
        case 'user-disabled':
          debugPrint('This account has been disabled.');
          break;
      }
      return null;
    }
  }

  @override
  Future<void> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;

      // 1. Safe Check: Ensure user is logged in
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      await _reauthenticate(oldPassword);

      // 3. Update Password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      // 4. Handle specific Firebase errors
      switch (e.code) {
        case 'wrong-password':
          throw Exception("The old password you entered is incorrect.");
        case 'weak-password':
          throw Exception("The new password is too weak.");
        case 'requires-recent-login':
          throw Exception("Please log in again before changing your password.");
        default:
          throw Exception(
            e.message ?? "An unknown authentication error occurred.",
          );
      }
    } catch (e) {
      // Handle non-Firebase errors (like network issues)
      throw Exception("Connection failed. Please try again later.");
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
        profileLink: customer.profileLink,
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

  @override
  Future<void> changeEmail(String newEmail, String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // This is the modern replacement for updateEmail()
      await user?.verifyBeforeUpdateEmail(newEmail);

      // UI: "Check your new email to confirm the switch!"
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Re-authenticate logic here
        await _reauthenticate(password);
      }
    }
  }

  Future<void> sendResetLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Success: Tell the user to check their inbox
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      }
    }
  }

  @override
  Future<String?> getSubscriptionStatus(String restaurantId) async {
    final restaurantDoc = await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .get();
    if (!restaurantDoc.exists) return null;
    final data = restaurantDoc.data() as Map<String, dynamic>;
    print('subscription status is:${data['subscriptionStatus']}');
    return data['subscriptionStatus'] as String?;
  }

  @override
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();

    if (!userDoc.exists) throw Exception("User not found");

    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> _reauthenticate(String password) async {
    final user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!, // The current (potentially fake) email
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }
}
