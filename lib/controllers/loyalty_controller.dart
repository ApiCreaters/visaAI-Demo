import 'package:get/get.dart';
import 'package:wallet_rewards/services/firestore_service.dart';
import 'package:wallet_rewards/services/loyalty_service.dart';
import 'package:wallet_rewards/models/loyalty_card.dart';
import 'package:wallet_rewards/models/reward.dart';
import 'package:wallet_rewards/models/loyalty_transaction.dart';

/// Loyalty GetX controller for managing cards, rewards, and transactions
class LoyaltyController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final LoyaltyService _loyaltyService = LoyaltyService();

  final RxList<LoyaltyCard> loyaltyCards = RxList<LoyaltyCard>();
  final Rx<LoyaltyCard?> selectedCard = Rx<LoyaltyCard?>(null);
  final RxList<Reward> availableRewards = RxList<Reward>();
  final RxList<LoyaltyTransaction> transactions = RxList<LoyaltyTransaction>();
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');

  /// Get user's loyalty cards
  Future<void> getUserLoyaltyCards(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final cards = await _firestoreService.getUserLoyaltyCards(userId);
      loyaltyCards.assignAll(cards);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a loyalty card
  void selectCard(LoyaltyCard card) {
    selectedCard.value = card;
    loadCardTransactions(card.id);
  }

  /// Create new loyalty card
  Future<bool> createLoyaltyCard({
    required String userId,
    required String restaurantId,
    required String restaurantName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final cardNumber =
          _loyaltyService.generateCardNumber(restaurantId.substring(0, 3));
      final card = LoyaltyCard(
        id: '${restaurantId}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        cardNumber: cardNumber,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createLoyaltyCard(card);
      loyaltyCards.add(card);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update card points
  Future<bool> updateCardPoints({
    required LoyaltyCard card,
    required int pointsChange,
    String? rewardId,
    String? description,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newPoints = card.currentPoints + pointsChange;
      if (newPoints < 0) {
        errorMessage.value = 'Insufficient points';
        return false;
      }

      final updatedCard = card.copyWith(
        currentPoints: newPoints,
        totalPointsEarned: card.totalPointsEarned + (pointsChange > 0 ? pointsChange : 0),
        lastUsedAt: DateTime.now(),
      );

      await _firestoreService.updateLoyaltyCard(updatedCard);

      // Create transaction
      final transaction = pointsChange > 0
          ? _loyaltyService.createEarnTransaction(
              cardId: card.id,
              userId: card.userId,
              restaurantId: card.restaurantId,
              pointsEarned: pointsChange,
              currentBalance: card.currentPoints,
            )
          : _loyaltyService.createRedeemTransaction(
              cardId: card.id,
              userId: card.userId,
              restaurantId: card.restaurantId,
              rewardId: rewardId ?? '',
              pointsRedeemed: pointsChange.abs(),
              currentBalance: card.currentPoints,
              rewardTitle: description ?? 'Reward',
            );

      await _firestoreService.createTransaction(transaction);

      // Update local state
      selectedCard.value = updatedCard;
      final index = loyaltyCards.indexWhere((c) => c.id == card.id);
      if (index != -1) {
        loyaltyCards[index] = updatedCard;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get restaurant rewards
  Future<void> getRestaurantRewards(String restaurantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final rewards = await _firestoreService.getRestaurantRewards(restaurantId);
      availableRewards.assignAll(rewards);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load card transactions
  Future<void> loadCardTransactions(String cardId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final txns = await _firestoreService.getCardTransactions(cardId);
      transactions.assignAll(txns);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Get total points across all cards
  int getTotalPoints() {
    return loyaltyCards.fold(0, (sum, card) => sum + card.currentPoints);
  }

  /// Get tier for selected card
  String? getSelectedCardTier() {
    if (selectedCard.value == null) return null;
    return _loyaltyService.getPointsTier(selectedCard.value!.totalPointsEarned);
  }

  /// Get tier progress for selected card
  double? getSelectedCardTierProgress() {
    if (selectedCard.value == null) return null;
    return _loyaltyService.getTierProgressPercentage(selectedCard.value!.totalPointsEarned);
  }
}
