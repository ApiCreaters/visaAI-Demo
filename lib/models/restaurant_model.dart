import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantCampaign {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String description;
  final String? logo;
  final String? bannerImage;
  final double latitude;
  final double longitude;
  final String address;
  final int pointsPerVisit;
  final List<LoyaltyReward> rewards;
  final String qrCodeUrl;
  final DateTime createdAt;
  final bool isActive;

  RestaurantCampaign({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.description,
    this.logo,
    this.bannerImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.pointsPerVisit = 10,
    this.rewards = const [],
    required this.qrCodeUrl,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'description': description,
      'logo': logo,
      'bannerImage': bannerImage,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pointsPerVisit': pointsPerVisit,
      'rewards': rewards.map((r) => r.toMap()).toList(),
      'qrCodeUrl': qrCodeUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory RestaurantCampaign.fromMap(Map<String, dynamic> map) {
    return RestaurantCampaign(
      id: map['id'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      description: map['description'] ?? '',
      logo: map['logo'],
      bannerImage: map['bannerImage'],
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
      pointsPerVisit: map['pointsPerVisit'] ?? 10,
      rewards: (map['rewards'] as List<dynamic>?)
              ?.map((r) => LoyaltyReward.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      qrCodeUrl: map['qrCodeUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  RestaurantCampaign copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? description,
    String? logo,
    String? bannerImage,
    double? latitude,
    double? longitude,
    String? address,
    int? pointsPerVisit,
    List<LoyaltyReward>? rewards,
    String? qrCodeUrl,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return RestaurantCampaign(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      bannerImage: bannerImage ?? this.bannerImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      pointsPerVisit: pointsPerVisit ?? this.pointsPerVisit,
      rewards: rewards ?? this.rewards,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class LoyaltyReward {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String? offerValue; // e.g., "Free drink", "20% discount"
  final DateTime expiryDate;
  final bool isActive;

  LoyaltyReward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.offerValue,
    required this.expiryDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsRequired': pointsRequired,
      'offerValue': offerValue,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'isActive': isActive,
    };
  }

  factory LoyaltyReward.fromMap(Map<String, dynamic> map) {
    return LoyaltyReward(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pointsRequired: map['pointsRequired'] ?? 100,
      offerValue: map['offerValue'],
      expiryDate: (map['expiryDate'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  LoyaltyReward copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsRequired,
    String? offerValue,
    DateTime? expiryDate,
    bool? isActive,
  }) {
    return LoyaltyReward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      offerValue: offerValue ?? this.offerValue,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
