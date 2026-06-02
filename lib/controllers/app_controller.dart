import 'package:get/get.dart';
import '../models/index.dart';
import '../services/index.dart';

class AppController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final LocationService locationService = Get.find<LocationService>();
  final NotificationService notificationService = Get.find<NotificationService>();

  Rx<CustomerUser?> currentUser = Rx<CustomerUser?>(null);
  RxList<RestaurantCampaign> nearbyRestaurants = RxList<RestaurantCampaign>();
  RxList<LoyaltyCard> userLoyaltyCards = RxList<LoyaltyCard>();
  RxList<Notification> userNotifications = RxList<Notification>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    if (authService.isAuthenticated) {
      currentUser.value =
          await firebaseService.getUser(authService.firebaseUser!.uid);
      _listenToUserData();
      _listenToNearbyRestaurants();
      _listenToUserLoyaltyCards();
      _listenToUserNotifications();
    }
  }

  void _listenToUserData() {
    if (currentUser.value != null) {
      firebaseService
          .userLoyaltyCardsStream(currentUser.value!.id)
          .listen((cards) {
        userLoyaltyCards.value = cards;
      });
    }
  }

  void _listenToNearbyRestaurants() async {
    firebaseService.campaignsStream().listen((campaigns) {
      nearbyRestaurants.value = locationService.getNearbyRestaurants(campaigns);
    });
  }

  void _listenToUserLoyaltyCards() {
    if (currentUser.value != null) {
      firebaseService
          .userLoyaltyCardsStream(currentUser.value!.id)
          .listen((cards) {
        userLoyaltyCards.value = cards;
      });
    }
  }

  void _listenToUserNotifications() {
    if (currentUser.value != null) {
      firebaseService
          .userNotificationsStream(currentUser.value!.id)
          .listen((notifications) {
        userNotifications.value = notifications;
      });
    }
  }

  /// Get loyalty card for a specific restaurant
  LoyaltyCard? getLoyaltyCardForRestaurant(String restaurantId) {
    try {
      return userLoyaltyCards.firstWhere(
        (card) => card.restaurantId == restaurantId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if user has enrolled in a restaurant
  bool isEnrolledInRestaurant(String restaurantId) {
    return getLoyaltyCardForRestaurant(restaurantId) != null;
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await firebaseService.markNotificationAsRead(notificationId);
  }

  /// Sign out user
  Future<void> signOut() async {
    await authService.signOut();
    currentUser.value = null;
    userLoyaltyCards.clear();
    userNotifications.clear();
  }

  /// Check for re-engagement candidates (no visit for 30 days)
  List<LoyaltyCard> getReEngagementCandidates() {
    DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    return userLoyaltyCards
        .where((card) => card.lastPointsEarned.isBefore(thirtyDaysAgo))
        .toList();
  }

  /// Trigger re-engagement notifications
  Future<void> triggerReEngagementCampaign() async {
    List<LoyaltyCard> candidates = getReEngagementCandidates();
    for (var card in candidates) {
      await notificationService.sendReEngagementNotification(
        userId: currentUser.value!.id,
        restaurantName: card.restaurantName,
      );
    }
  }

  /// Generate personalized offers based on user behavior
  Future<void> generatePersonalizedOffers() async {
    if (currentUser.value == null) return;

    for (var card in userLoyaltyCards) {
      // Frequent visitor: 10+ visits in last 90 days
      int recentVisits = card.transactions
          .where((t) =>
              t.type == 'earned' &&
              t.timestamp.isAfter(DateTime.now().subtract(Duration(days: 90))))
          .length;

      if (recentVisits >= 10) {
        // Generate offer for frequent visitors
        AIGeneratedOffer offer = AIGeneratedOffer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerId: currentUser.value!.id,
          restaurantId: card.restaurantId,
          offerTitle: 'Loyalty Reward - Frequent Visitor',
          offerDescription: 'Enjoy 20% off on your next visit!',
          reason: 'frequently visits',
          discountPercentage: 20,
          expiryDate: DateTime.now().add(Duration(days: 7)),
          createdAt: DateTime.now(),
        );
        await firebaseService.saveAIGeneratedOffer(offer);
      }

      // Idle customer: no visit for 30 days
      if (card.lastPointsEarned
          .isBefore(DateTime.now().subtract(Duration(days: 30)))) {
        AIGeneratedOffer offer = AIGeneratedOffer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerId: currentUser.value!.id,
          restaurantId: card.restaurantId,
          offerTitle: 'We Miss You!',
          offerDescription: 'Get £5 off your next visit',
          reason: 'hasn\'t visited in 30 days',
          pointsOffer: 50,
          expiryDate: DateTime.now().add(Duration(days: 14)),
          createdAt: DateTime.now(),
        );
        await firebaseService.saveAIGeneratedOffer(offer);
      }

      // High spender: more than 500 points earned
      if (card.currentPoints > 500) {
        AIGeneratedOffer offer = AIGeneratedOffer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerId: currentUser.value!.id,
          restaurantId: card.restaurantId,
          offerTitle: 'VIP Exclusive Offer',
          offerDescription: 'Free appetizer with any main course',
          reason: 'high spender',
          discountPercentage: 0,
          expiryDate: DateTime.now().add(Duration(days: 30)),
          createdAt: DateTime.now(),
        );
        await firebaseService.saveAIGeneratedOffer(offer);
      }
    }
  }
}
