import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';
import '../services/index.dart';

class LoyaltyCardController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AppController appController = Get.find<AppController>();

  RxList<LoyaltyCard> loyaltyCards = RxList<LoyaltyCard>();
  Rx<LoyaltyCard?> selectedCard = Rx<LoyaltyCard?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLoyaltyCards();
  }

  Future<void> loadLoyaltyCards() async {
    isLoading.value = true;
    try {
      String userId = appController.currentUser.value?.id ?? '';
      List<LoyaltyCard> cards =
          await firebaseService.getUserLoyaltyCards(userId);
      loyaltyCards.value = cards;
    } catch (e) {
      errorMessage.value = 'Error loading loyalty cards: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Enroll in a restaurant loyalty program
  Future<bool> enrollInRestaurant(RestaurantCampaign campaign) async {
    try {
      String userId = appController.currentUser.value?.id ?? '';
      String barcode = const Uuid().v4().replaceAll('-', '').substring(0, 12);

      LoyaltyCard newCard = LoyaltyCard(
        id: const Uuid().v4(),
        customerId: userId,
        restaurantId: campaign.id,
        restaurantName: campaign.restaurantName,
        currentPoints: 0,
        transactions: [],
        redeemedRewards: [],
        enrolledAt: DateTime.now(),
        lastPointsEarned: DateTime.now(),
        barcode: barcode,
      );

      await firebaseService.saveLoyaltyCard(newCard);
      await firebaseService.addRestaurantToUser(userId, campaign.id);

      loyaltyCards.add(newCard);
      selectedCard.value = newCard;
      errorMessage.value = '';
      return true;
    } catch (e) {
      errorMessage.value = 'Error enrolling in restaurant: $e';
      return false;
    }
  }

  /// Add points to a loyalty card
  Future<bool> addPoints(String cardId, int points, String description) async {
    try {
      await firebaseService.addPointsToCard(cardId, points, description);

      // Update local card
      LoyaltyCard? card = loyaltyCards.firstWhereOrNull((c) => c.id == cardId);
      if (card != null) {
        int index = loyaltyCards.indexOf(card);
        LoyaltyCard updatedCard = card.copyWith(
          currentPoints: card.currentPoints + points,
          lastPointsEarned: DateTime.now(),
        );
        loyaltyCards[index] = updatedCard;
        selectedCard.value = updatedCard;
      }

      // Update user total points
      if (appController.currentUser.value != null) {
        await firebaseService.updateUserPoints(
          appController.currentUser.value!.id,
          points,
        );
      }

      errorMessage.value = '';
      return true;
    } catch (e) {
      errorMessage.value = 'Error adding points: $e';
      return false;
    }
  }

  /// Redeem a reward
  Future<bool> redeemReward(
    String cardId,
    LoyaltyReward reward,
  ) async {
    try {
      LoyaltyCard? card = loyaltyCards.firstWhereOrNull((c) => c.id == cardId);
      if (card == null || card.currentPoints < reward.pointsRequired) {
        errorMessage.value = 'Insufficient points';
        return false;
      }

      String code = const Uuid().v4().replaceAll('-', '').substring(0, 8);
      RedeemedReward redeemedReward = RedeemedReward(
        id: const Uuid().v4(),
        rewardId: reward.id,
        rewardTitle: reward.title,
        pointsUsed: reward.pointsRequired,
        redeemedAt: DateTime.now(),
        code: code,
        status: 'redeemed',
      );

      await firebaseService.redeemReward(cardId, redeemedReward);

      // Update local card
      int index = loyaltyCards.indexOf(card);
      LoyaltyCard updatedCard = card.copyWith(
        currentPoints: card.currentPoints - reward.pointsRequired,
      );
      loyaltyCards[index] = updatedCard;
      selectedCard.value = updatedCard;

      errorMessage.value = '';
      return true;
    } catch (e) {
      errorMessage.value = 'Error redeeming reward: $e';
      return false;
    }
  }

  /// Select a card to view details
  void selectCard(LoyaltyCard card) {
    selectedCard.value = card;
  }

  /// Get points progress for next reward
  int getPointsForNextReward(LoyaltyCard card) {
    if (card.currentPoints >= 100) {
      return 0; // User can redeem now
    }
    return 100 - card.currentPoints;
  }

  /// Get available rewards for a card
  List<LoyaltyReward> getAvailableRewards(RestaurantCampaign campaign) {
    if (selectedCard.value == null) return [];
    return campaign.rewards
        .where((reward) =>
            selectedCard.value!.currentPoints >= reward.pointsRequired &&
            reward.isActive)
        .toList();
  }

  /// Get transaction history
  List<PointsTransaction> getTransactionHistory(String cardId) {
    LoyaltyCard? card = loyaltyCards.firstWhereOrNull((c) => c.id == cardId);
    if (card == null) return [];
    return card.transactions
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
