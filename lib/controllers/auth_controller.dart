import 'package:get/get.dart';
import '../models/index.dart';
import '../services/index.dart';

class AuthController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final FirebaseService firebaseService = Get.find<FirebaseService>();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<CustomerUser?> currentUser = Rx<CustomerUser?>(null);

  // Form fields
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString name = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (authService.isAuthenticated) {
      _loadUserData();
    }
  }

  void _loadUserData() async {
    if (authService.firebaseUser != null) {
      currentUser.value =
          await firebaseService.getUser(authService.firebaseUser!.uid);
    }
  }

  Future<bool> signUp() async {
    if (!_validateSignUpForm()) {
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      bool success = await authService.signUp(
        email: email.value,
        phone: phone.value,
        name: name.value,
        password: password.value,
      );

      if (success && authService.firebaseUser != null) {
        // Save user to Firestore
        CustomerUser newUser = CustomerUser(
          id: authService.firebaseUser!.uid,
          email: email.value,
          phone: phone.value,
          name: name.value,
          totalPoints: 0,
          enrolledRestaurants: [],
          redeemedRewards: [],
          createdAt: DateTime.now(),
          lastActivity: DateTime.now(),
          referralCode: authService.currentUser.value?.referralCode ?? '',
        );

        await firebaseService.saveUser(newUser);
        currentUser.value = newUser;
        _clearForm();
        return true;
      }
      errorMessage.value = 'Failed to create account';
      return false;
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signIn() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      bool success = await authService.signIn(
        email: email.value,
        password: password.value,
      );

      if (success) {
        _loadUserData();
        _clearForm();
        return true;
      }
      errorMessage.value = 'Invalid credentials';
      return false;
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword() async {
    if (email.value.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      bool success = await authService.resetPassword(email: email.value);
      if (success) {
        errorMessage.value = 'Check your email for password reset link';
        return true;
      }
      errorMessage.value = 'Failed to send reset email';
      return false;
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    currentUser.value = null;
    _clearForm();
  }

  bool _validateSignUpForm() {
    if (email.value.isEmpty ||
        phone.value.isEmpty ||
        name.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return false;
    }

    if (!_isValidEmail(email.value)) {
      errorMessage.value = 'Invalid email format';
      return false;
    }

    if (password.value != confirmPassword.value) {
      errorMessage.value = 'Passwords do not match';
      return false;
    }

    if (password.value.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _clearForm() {
    email.value = '';
    phone.value = '';
    name.value = '';
    password.value = '';
    confirmPassword.value = '';
  }

  // Update form fields
  void setEmail(String value) => email.value = value;
  void setPhone(String value) => phone.value = value;
  void setName(String value) => name.value = value;
  void setPassword(String value) => password.value = value;
  void setConfirmPassword(String value) => confirmPassword.value = value;
}
