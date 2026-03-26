import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';

class AuthService {
  AuthRepository _authRepository;
  UserRepository<Customer> _customerRepository;
  UserRepository<StoreUser> _storeUserRepository;
  UserProvider _userProvider;

  AuthService({
    required AuthRepository authRepository,
    required UserProvider userProvider,
    required UserRepository<Customer> customerRepository,
    required UserRepository<StoreUser> storeUserRepository,
  }) : _authRepository = authRepository,
       _userProvider = userProvider,
       _customerRepository = customerRepository,
       _storeUserRepository = storeUserRepository;

  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  // This is authentication User not our class User
  Future<String?> getUserRole(User authUser) async {
    final doc = await _firebaseStore
        .collection('users')
        .doc(authUser.uid)
        .get();

    if (!doc.exists) return null;
    return doc['userType'] as String;
  }

  Future<bool> checkSubscriptionStatus(User authUser) async {
    final userData = await _authRepository.getUserData(authUser.uid);
    final status = await _authRepository.getSubscriptionStatus(
      userData['restaurantId'] as String,
    );
    print('Auth Service: The subscription status is ${status}');
    return status!.toLowerCase() == 'active';
  }

  Future<User?> register(Customer customer, String password) async {
    User? user = await _authRepository.register(customer, password);
    if (user == null) return null;

    return await login(customer.email, password);
  }

  Future<User?> login(String email, String password) async {
    User? user = await _authRepository.login(email, password);
    if (user == null) return null;

    String? role = await getUserRole(user);
    if (role == null || role.isEmpty) return null;

    final bool status = await checkSubscriptionStatus(user);

    switch (role) {
      case "customer":
        {
          Customer? customer = await _customerRepository.getUserById(user.uid);
          if (customer == null) return null;
          _userProvider.updateUser(customer);
        }
        break;
      case "store":
        {
          StoreUser? storeUser = await _storeUserRepository.getUserById(
            user.uid,
          );
          if (storeUser == null) return null;
          if (!status) {
            print("Subscription expired");
            return null; // login fails gracefully
          }
          _userProvider.updateUser(storeUser);
        }
        break;
    }

    return user;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authRepository.changePassword(
      _userProvider.asStoreUser!.email,
      oldPassword,
      newPassword,
    );
  }

  Future<void> sendResetPasswordLink(String email) async {
    await _authRepository.sendResetLink(email);
  }

  Future<void> changeEmail(String newEmail, String password) async {
    try {
      await _authRepository.changeEmail(newEmail, password);
      if (_userProvider.asStoreUser != null) {
        await _storeUserRepository.update(
          _userProvider.asStoreUser!.copyWith(email: newEmail),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void signOut() {
    _authRepository.signOut();
    _userProvider.updateUser(null);
  }

  Future<void> restoreSession() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _userProvider.setRestored();
        return;
      }

      debugPrint("Restore attempt for: ${firebaseUser.uid}");

      // Wrap the entire restoration logic in a timeout
      await _performRestoration(firebaseUser).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint("Restoration timed out. Forcing navigation to Auth.");
        },
      );
    } catch (e) {
      debugPrint("Restoration failed with error: $e");
    } finally {
      _userProvider.setRestored();
    }
  }

  /// Helper method to keep the main method clean
  Future<void> _performRestoration(User firebaseUser) async {
    String? role = await getUserRole(firebaseUser);
    if (role == null || role.isEmpty) return;

    switch (role) {
      case "customer":
        Customer? customer = await _customerRepository.getUserById(
          firebaseUser.uid,
        );
        if (customer != null) _userProvider.updateUser(customer);
        break;
      case "store":
        StoreUser? storeUser = await _storeUserRepository.getUserById(
          firebaseUser.uid,
        );
        if (storeUser == null) return;

        final bool isActive = await checkSubscriptionStatus(firebaseUser);
        if(!isActive){
          print("Subscription expired on restore, signing out...");
          signOut();
          return;
        }
        _userProvider.updateUser(storeUser);
        break;
    }
  }

  void updateDependencies({
    required AuthRepository authRepository,
    required UserProvider userProvider,
    required UserRepository<Customer> customerRepository,
    required UserRepository<StoreUser> storeUserRepository,
  }) {
    _authRepository = authRepository;
    _userProvider = userProvider;
    _customerRepository = customerRepository;
    _storeUserRepository = storeUserRepository;
  }
}
