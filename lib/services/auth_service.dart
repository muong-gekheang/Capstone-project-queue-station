import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/user/production/customer_repository_impl.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  final CustomerRepositoryImpl _customerRepository = CustomerRepositoryImpl();

  User? currentUser;

  // Real login using Firebase
  Future<User?> login(String email, String password) async {
    try {
      final firebaseUser = await _authRepository.login(email, password);

      if (firebaseUser != null) {
        // Fetch the customer data from Firestore
        final customer = await _customerRepository.getUserById(
          firebaseUser.uid,
        );
        currentUser = customer;
        return customer;
      }

      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Real registration using Firebase
  Future<bool> register({
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final newUser = Customer(
        name: username,
        email: email,
        phone: phoneNumber,
        id: '', // Will be set by the repository after Firebase Auth creates the user
        historyIds: [],
      );

      final firebaseUser = await _authRepository.register(newUser, password);

      if (firebaseUser != null) {
        currentUser = newUser.copyWith(id: firebaseUser.uid);
        return true;
      }

      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _authRepository.signOut();
    currentUser = null;
  }
}
