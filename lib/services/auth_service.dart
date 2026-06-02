import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  Rx<CustomerUser?> currentUser = Rx<CustomerUser?>(null);

  AuthService() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _auth.authStateChanges().listen((User? user) {
      _firebaseUser.value = user;
    });
  }

  User? get firebaseUser => _firebaseUser.value;
  bool get isAuthenticated => _firebaseUser.value != null;

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String phone,
    required String name,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create CustomerUser model
        CustomerUser newUser = CustomerUser(
          id: result.user!.uid,
          email: email,
          phone: phone,
          name: name,
          totalPoints: 0,
          enrolledRestaurants: [],
          redeemedRewards: [],
          createdAt: DateTime.now(),
          lastActivity: DateTime.now(),
          referralCode: _generateReferralCode(),
        );

        currentUser.value = newUser;
        return true;
      }
      return false;
    } catch (e) {
      print('SignUp Error: $e');
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      print('SignIn Error: $e');
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
    } catch (e) {
      print('SignOut Error: $e');
    }
  }

  /// Generate unique referral code
  String _generateReferralCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[(DateTime.now().millisecond + i) % chars.length];
    }
    return code;
  }

  /// Reset password
  Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password Reset Error: $e');
      return false;
    }
  }
}
