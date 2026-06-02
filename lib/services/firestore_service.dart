import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_rewards/models/loyalty_card.dart';
import 'package:wallet_rewards/models/customer.dart';
import 'package:wallet_rewards/models/reward.dart';
import 'package:wallet_rewards/models/loyalty_transaction.dart';
import 'package:wallet_rewards/models/restaurant.dart';

/// Firestore database service for CRUD operations
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collections
  static const String customersCollection = 'customers';
  static const String loyaltyCardsCollection = 'loyalty_cards';
  static const String rewardsCollection = 'rewards';
  static const String transactionsCollection = 'transactions';
  static const String restaurantsCollection = 'restaurants';

  // ===================== Customer Operations =====================
  Future<void> createCustomer(Customer customer) async {
    try {
      await _db
          .collection(customersCollection)
          .doc(customer.id)
          .set(customer.toJson());
    } catch (e) {
      throw 'Failed to create customer: $e';
    }
  }

  Future<Customer?> getCustomer(String customerId) async {
    try {
      final doc =
          await _db.collection(customersCollection).doc(customerId).get();
      if (doc.exists) {
        return Customer.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get customer: $e';
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _db
          .collection(customersCollection)
          .doc(customer.id)
          .update(customer.toJson());
    } catch (e) {
      throw 'Failed to update customer: $e';
    }
  }

  // ===================== Loyalty Card Operations =====================
  Future<void> createLoyaltyCard(LoyaltyCard card) async {
    try {
      await _db
          .collection(loyaltyCardsCollection)
          .doc(card.id)
          .set(card.toJson());
    } catch (e) {
      throw 'Failed to create loyalty card: $e';
    }
  }

  Future<LoyaltyCard?> getLoyaltyCard(String cardId) async {
    try {
      final doc =
          await _db.collection(loyaltyCardsCollection).doc(cardId).get();
      if (doc.exists) {
        return LoyaltyCard.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get loyalty card: $e';
    }
  }

  Future<List<LoyaltyCard>> getUserLoyaltyCards(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(loyaltyCardsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => LoyaltyCard.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get user loyalty cards: $e';
    }
  }

  Future<void> updateLoyaltyCard(LoyaltyCard card) async {
    try {
      await _db
          .collection(loyaltyCardsCollection)
          .doc(card.id)
          .update(card.toJson());
    } catch (e) {
      throw 'Failed to update loyalty card: $e';
    }
  }

  // ===================== Reward Operations =====================
  Future<void> createReward(Reward reward) async {
    try {
      await _db.collection(rewardsCollection).doc(reward.id).set(reward.toJson());
    } catch (e) {
      throw 'Failed to create reward: $e';
    }
  }

  Future<Reward?> getReward(String rewardId) async {
    try {
      final doc = await _db.collection(rewardsCollection).doc(rewardId).get();
      if (doc.exists) {
        return Reward.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get reward: $e';
    }
  }

  Future<List<Reward>> getRestaurantRewards(String restaurantId) async {
    try {
      final querySnapshot = await _db
          .collection(rewardsCollection)
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isAvailable', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Reward.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get restaurant rewards: $e';
    }
  }

  // ===================== Transaction Operations =====================
  Future<void> createTransaction(LoyaltyTransaction transaction) async {
    try {
      await _db
          .collection(transactionsCollection)
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      throw 'Failed to create transaction: $e';
    }
  }

  Future<List<LoyaltyTransaction>> getCardTransactions(
    String cardId, {
    int limit = 50,
  }) async {
    try {
      final querySnapshot = await _db
          .collection(transactionsCollection)
          .where('cardId', isEqualTo: cardId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => LoyaltyTransaction.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get card transactions: $e';
    }
  }

  // ===================== Restaurant Operations =====================
  Future<void> createRestaurant(Restaurant restaurant) async {
    try {
      await _db
          .collection(restaurantsCollection)
          .doc(restaurant.id)
          .set(restaurant.toJson());
    } catch (e) {
      throw 'Failed to create restaurant: $e';
    }
  }

  Future<Restaurant?> getRestaurant(String restaurantId) async {
    try {
      final doc =
          await _db.collection(restaurantsCollection).doc(restaurantId).get();
      if (doc.exists) {
        return Restaurant.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get restaurant: $e';
    }
  }

  Future<List<Restaurant>> getAllRestaurants({
    int limit = 100,
  }) async {
    try {
      final querySnapshot = await _db
          .collection(restaurantsCollection)
          .where('isActive', isEqualTo: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get restaurants: $e';
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final querySnapshot = await _db
          .collection(restaurantsCollection)
          .where('isActive', isEqualTo: true)
          .get();

      final results = querySnapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data()))
          .toList();

      // Client-side filtering (Firebase doesn't support full-text search)
      return results
          .where((r) =>
              r.name.toLowerCase().contains(query.toLowerCase()) ||
              r.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw 'Failed to search restaurants: $e';
    }
  }
}
