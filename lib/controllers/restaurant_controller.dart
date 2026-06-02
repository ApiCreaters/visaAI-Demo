import 'package:get/get.dart';
import '../models/index.dart';
import '../services/index.dart';

class RestaurantController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final LocationService locationService = Get.find<LocationService>();
  final AppController appController = Get.find<AppController>();

  RxList<RestaurantCampaign> allRestaurants = RxList<RestaurantCampaign>();
  RxList<RestaurantCampaign> nearbyRestaurants = RxList<RestaurantCampaign>();
  Rx<RestaurantCampaign?> selectedRestaurant = Rx<RestaurantCampaign?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRestaurants();
    loadNearbyRestaurants();
  }

  Future<void> loadRestaurants() async {
    isLoading.value = true;
    try {
      List<RestaurantCampaign> restaurants =
          await firebaseService.getAllCampaigns();
      allRestaurants.value = restaurants;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error loading restaurants: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNearbyRestaurants() async {
    try {
      firebaseService.campaignsStream().listen((restaurants) {
        List<RestaurantCampaign> nearby =
            locationService.getNearbyRestaurants(restaurants);
        nearbyRestaurants.value = nearby;
      });
    } catch (e) {
      errorMessage.value = 'Error loading nearby restaurants: $e';
    }
  }

  /// Search restaurants by name
  List<RestaurantCampaign> searchRestaurants(String query) {
    if (query.isEmpty) return allRestaurants;
    return allRestaurants
        .where((r) =>
            r.restaurantName.toLowerCase().contains(query.toLowerCase()) ||
            r.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get distance to restaurant
  double getDistanceToRestaurant(RestaurantCampaign restaurant) {
    if (locationService.currentPosition.value == null) return 0;
    return locationService.calculateDistance(
      locationService.currentPosition.value!.latitude,
      locationService.currentPosition.value!.longitude,
      restaurant.latitude,
      restaurant.longitude,
    );
  }

  /// Select restaurant
  void selectRestaurant(RestaurantCampaign restaurant) {
    selectedRestaurant.value = restaurant;
  }

  /// Check if user is enrolled in restaurant
  bool isEnrolled(RestaurantCampaign restaurant) {
    return appController.isEnrolledInRestaurant(restaurant.id);
  }

  /// Get loyalty card for restaurant
  LoyaltyCard? getLoyaltyCard(RestaurantCampaign restaurant) {
    return appController.getLoyaltyCardForRestaurant(restaurant.id);
  }

  /// Get rewards for restaurant
  List<LoyaltyReward> getAvailableRewards(RestaurantCampaign restaurant) {
    LoyaltyCard? card = getLoyaltyCard(restaurant);
    if (card == null) return [];

    return restaurant.rewards
        .where((reward) =>
            card.currentPoints >= reward.pointsRequired &&
            reward.isActive &&
            reward.expiryDate.isAfter(DateTime.now()))
        .toList();
  }

  /// Get redeemable rewards (user has enough points)
  List<LoyaltyReward> getRedeemableRewards(RestaurantCampaign restaurant) {
    LoyaltyCard? card = getLoyaltyCard(restaurant);
    if (card == null) return [];

    return restaurant.rewards
        .where((reward) => card.currentPoints >= reward.pointsRequired)
        .toList();
  }
}
