import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

class FirebaseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  const FirebaseService();

  // ─── User Operations ───────────────────────────────────────────────────────
  Future<void> saveUser(CustomerUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  Future<CustomerUser?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return CustomerUser.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> updateUserPoints(String userId, int points) async {
    try {
      CustomerUser? user = await getUser(userId);
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .update({'totalPoints': user.totalPoints + points});
      }
    } catch (e) {
      print('Error updating user points: $e');
    }
  }

  Future<void> addRestaurantToUser(String userId, String restaurantId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'enrolledRestaurants': FieldValue.arrayUnion([restaurantId])
      });
    } catch (e) {
      print('Error adding restaurant to user: $e');
    }
  }

  // ─── Restaurant Campaign Operations ────────────────────────────────────────
  Future<void> saveCampaign(RestaurantCampaign campaign) async {
    try {
      await _firestore.collection('campaigns').doc(campaign.id).set(campaign.toMap());
    } catch (e) {
      print('Error saving campaign: $e');
    }
  }

  Future<RestaurantCampaign?> getCampaign(String campaignId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('campaigns').doc(campaignId).get();
      if (doc.exists) {
        return RestaurantCampaign.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting campaign: $e');
      return null;
    }
  }

  Future<List<RestaurantCampaign>> getAllCampaigns() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('campaigns')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => RestaurantCampaign.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting campaigns: $e');
      return [];
    }
  }

  Stream<List<RestaurantCampaign>> campaignsStream() {
    return _firestore
        .collection('campaigns')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RestaurantCampaign.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // ─── Loyalty Card Operations ───────────────────────────────────────────────
  Future<void> saveLoyaltyCard(LoyaltyCard card) async {
    try {
      await _firestore.collection('loyalty_cards').doc(card.id).set(card.toMap());
    } catch (e) {
      print('Error saving loyalty card: $e');
    }
  }

  Future<LoyaltyCard?> getLoyaltyCard(String cardId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('loyalty_cards').doc(cardId).get();
      if (doc.exists) {
        return LoyaltyCard.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting loyalty card: $e');
      return null;
    }
  }

  Future<List<LoyaltyCard>> getUserLoyaltyCards(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('loyalty_cards')
          .where('customerId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => LoyaltyCard.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user loyalty cards: $e');
      return [];
    }
  }

  Stream<List<LoyaltyCard>> userLoyaltyCardsStream(String userId) {
    return _firestore
        .collection('loyalty_cards')
        .where('customerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoyaltyCard.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addPointsToCard(String cardId, int points, String description) async {
    try {
      LoyaltyCard? card = await getLoyaltyCard(cardId);
      if (card != null) {
        PointsTransaction transaction = PointsTransaction(
          id: const Uuid().v4(),
          points: points,
          type: 'earned',
          description: description,
          timestamp: DateTime.now(),
        );

        await _firestore.collection('loyalty_cards').doc(cardId).update({
          'currentPoints': card.currentPoints + points,
          'transactions': FieldValue.arrayUnion([transaction.toMap()]),
          'lastPointsEarned': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error adding points to card: $e');
    }
  }

  Future<void> redeemReward(String cardId, RedeemedReward reward) async {
    try {
      LoyaltyCard? card = await getLoyaltyCard(cardId);
      if (card != null && card.currentPoints >= reward.pointsUsed) {
        PointsTransaction transaction = PointsTransaction(
          id: const Uuid().v4(),
          points: -reward.pointsUsed,
          type: 'redeemed',
          description: 'Redeemed: ${reward.rewardTitle}',
          timestamp: DateTime.now(),
        );

        await _firestore.collection('loyalty_cards').doc(cardId).update({
          'currentPoints': card.currentPoints - reward.pointsUsed,
          'transactions': FieldValue.arrayUnion([transaction.toMap()]),
          'redeemedRewards': FieldValue.arrayUnion([reward.toMap()]),
        });
      }
    } catch (e) {
      print('Error redeeming reward: $e');
    }
  }

  // ─── Notification Operations ───────────────────────────────────────────────
  Future<void> saveNotification(Notification notification) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  Future<List<Notification>> getUserNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => Notification.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  Stream<List<Notification>> userNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notification.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // ─── Referral Operations ───────────────────────────────────────────────────
  Future<void> saveReferralProgram(ReferralProgram program) async {
    try {
      await _firestore
          .collection('referral_programs')
          .doc(program.id)
          .set(program.toMap());
    } catch (e) {
      print('Error saving referral program: $e');
    }
  }

  Future<ReferralProgram?> getReferralProgram(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('referral_programs')
          .where('referrerId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ReferralProgram.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting referral program: $e');
      return null;
    }
  }

  // ─── AI Generated Offers Operations ────────────────────────────────────────
  Future<void> saveAIGeneratedOffer(AIGeneratedOffer offer) async {
    try {
      await _firestore
          .collection('ai_generated_offers')
          .doc(offer.id)
          .set(offer.toMap());
    } catch (e) {
      print('Error saving AI generated offer: $e');
    }
  }

  Future<List<AIGeneratedOffer>> getUserOffers(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('ai_generated_offers')
          .where('customerId', isEqualTo: userId)
          .where('isApplied', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => AIGeneratedOffer.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user offers: $e');
      return [];
    }
  }
}
