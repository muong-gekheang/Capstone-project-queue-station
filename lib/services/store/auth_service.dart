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
          _userProvider.updateUser(storeUser);
        }
        break;
    }

    return user;
  }

  void signOut() {
    _authRepository.signOut();
    _userProvider.updateUser(null);
  }

  Future<void> restoreSession() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _userProvider.setRestored();
      return;
    }

    debugPrint("Restore: $firebaseUser");

    // Re-use your existing login logic to repopulate UserProvider
    String? role = await getUserRole(firebaseUser);
    if (role == null || role.isEmpty) return;

    switch (role) {
      case "customer":
        Customer? customer = await _customerRepository.getUserById(
          firebaseUser.uid,
        );
        if (customer == null) return;
        _userProvider.updateUser(customer);
        break;
      case "store":
        StoreUser? storeUser = await _storeUserRepository.getUserById(
          firebaseUser.uid,
        );
        if (storeUser == null) return;
        _userProvider.updateUser(storeUser);
        break;
    }
    _userProvider.setRestored();
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
