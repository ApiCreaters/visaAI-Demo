import 'package:get/get.dart';
import 'package:wallet_rewards/services/firestore_service.dart';
import 'package:wallet_rewards/models/customer.dart';

/// User profile GetX controller
class UserController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  final Rx<Customer?> currentUser = Rx<Customer?>(null);
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');

  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _firestoreService.getCustomer(userId);
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedUser = currentUser.value?.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        updatedAt: DateTime.now(),
      );

      if (updatedUser != null) {
        await _firestoreService.updateCustomer(updatedUser);
        currentUser.value = updatedUser;
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

  /// Add favorite restaurant
  Future<bool> addFavoriteRestaurant(String restaurantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = currentUser.value;
      if (user != null) {
        final favorites = user.favoriteRestaurants ?? [];
        if (!favorites.contains(restaurantId)) {
          favorites.add(restaurantId);
          final updatedUser = user.copyWith(
            favoriteRestaurants: favorites,
            updatedAt: DateTime.now(),
          );
          await _firestoreService.updateCustomer(updatedUser);
          currentUser.value = updatedUser;
        }
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

  /// Remove favorite restaurant
  Future<bool> removeFavoriteRestaurant(String restaurantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = currentUser.value;
      if (user != null) {
        final favorites = user.favoriteRestaurants ?? [];
        favorites.remove(restaurantId);
        final updatedUser = user.copyWith(
          favoriteRestaurants: favorites,
          updatedAt: DateTime.now(),
        );
        await _firestoreService.updateCustomer(updatedUser);
        currentUser.value = updatedUser;
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

  /// Check if restaurant is favorite
  bool isFavoriteRestaurant(String restaurantId) {
    return currentUser.value?.favoriteRestaurants?.contains(restaurantId) ?? false;
  }

  /// Update user location
  Future<bool> updateUserLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedUser = currentUser.value?.copyWith(
        latitude: latitude,
        longitude: longitude,
        updatedAt: DateTime.now(),
      );

      if (updatedUser != null) {
        await _firestoreService.updateCustomer(updatedUser);
        currentUser.value = updatedUser;
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

  /// Clear user data
  void clearUserData() {
    currentUser.value = null;
    errorMessage.value = '';
  }
}
