import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../models/index.dart';

class LocationService extends GetxService {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  final double notificationRadius = 500; // meters

  Future<void> init() async {
    await _requestLocationPermission();
    startLocationUpdates();
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  void startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update every 100 meters
      ),
    ).listen((Position position) {
      currentPosition.value = position;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusMeters = 6371000;
    double dLat = _toRad(lat2 - lat1);
    double dLon = _toRad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.asin(math.sqrt(a));
    return earthRadiusMeters * c;
  }

  double _toRad(double degree) {
    return degree * math.pi / 180;
  }

  bool isNearRestaurant(RestaurantCampaign restaurant) {
    if (currentPosition.value == null) return false;
    double distance = calculateDistance(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      restaurant.latitude,
      restaurant.longitude,
    );
    return distance <= notificationRadius;
  }

  List<RestaurantCampaign> getNearbyRestaurants(
    List<RestaurantCampaign> allRestaurants,
  ) {
    if (currentPosition.value == null) return [];
    return allRestaurants.where((restaurant) => isNearRestaurant(restaurant)).toList();
  }
}
