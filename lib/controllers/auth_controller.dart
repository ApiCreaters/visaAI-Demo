import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallet_rewards/services/auth_service.dart';
import 'package:wallet_rewards/services/firestore_service.dart';
import 'package:wallet_rewards/models/customer.dart';

/// Authentication GetX controller
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');
  final RxBool isEmailVerified = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _setupAuthStateListener();
  }

  /// Setup auth state changes listener
  void _setupAuthStateListener() {
    _authService.authStateChanges.listen((user) {
      currentUser.value = user;
      if (user != null) {
        isEmailVerified.value = user.emailVerified;
      }
    });
  }

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser.value != null;

  /// Get current user ID
  String? get userId => currentUser.value?.uid;

  /// Register with email and password
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential = await _authService.registerWithEmail(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create customer document
        final customer = Customer(
          id: userCredential.user!.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          createdAt: DateTime.now(),
        );

        await _firestoreService.createCustomer(customer);

        // Update user profile
        await _authService.auth.currentUser?.updateProfile(
          displayName: '$firstName $lastName',
        );

        return true;
      }

      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      return userCredential.user != null;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.signOut();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.updatePassword(newPassword);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.auth.currentUser?.sendEmailVerification();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Reload user data
  Future<void> reloadUserData() async {
    try {
      await _authService.auth.currentUser?.reload();
      currentUser.value = _authService.auth.currentUser;
      isEmailVerified.value = _authService.auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
