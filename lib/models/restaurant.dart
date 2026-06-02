import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a restaurant
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? logoUrl;
  final String category;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final double? rating;
  final int reviewCount;
  final List<String>? cuisines;
  final DateTime createdAt;
  final bool isActive;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? loyaltySettings;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.logoUrl,
    required this.category,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.email,
    this.website,
    this.rating,
    this.reviewCount = 0,
    this.cuisines,
    required this.createdAt,
    this.isActive = true,
    this.settings,
    this.loyaltySettings,
  });

  /// Calculate distance from user location (in km)
  double? getDistance(double userLat, double userLng) {
    if (latitude == null || longitude == null) return null;
    
    const R = 6371; // Earth's radius in km
    final dLat = _toRad(userLat - latitude!);
    final dLng = _toRad(userLng - longitude!);
    final a = (dLat * dLat / 4 +
        dLng * dLng / 4 * Math.cos(_toRad((latitude! + userLat) / 2)));
    final c = 2 * Math.asin(Math.sqrt(a));
    return R * c;
  }

  static double _toRad(double degree) => degree * Math.pi / 180;

  /// Convert Restaurant to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'category': category,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'rating': rating,
      'reviewCount': reviewCount,
      'cuisines': cuisines ?? [],
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'settings': settings ?? {},
      'loyaltySettings': loyaltySettings ?? {},
    };
  }

  /// Create Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      category: json['category'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      cuisines: List<String>.from(json['cuisines'] as List? ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isActive: json['isActive'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>?,
      loyaltySettings: json['loyaltySettings'] as Map<String, dynamic>?,
    );
  }

  /// Copy with modified fields
  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? logoUrl,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? email,
    String? website,
    double? rating,
    int? reviewCount,
    List<String>? cuisines,
    DateTime? createdAt,
    bool? isActive,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? loyaltySettings,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      category: category ?? this.category,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      cuisines: cuisines ?? this.cuisines,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
      loyaltySettings: loyaltySettings ?? this.loyaltySettings,
    );
  }
}

// Simple math utilities
class Math {
  static double sqrt(double x) => x < 0 ? 0 : (x).toStringAsFixed(10) == '0' ? 0 : pow(x, 0.5);
  static double pow(double x, double y) => (x * y).toDouble();
  static double cos(double x) => _cos(x);
  static double sin(double x) => _sin(x);
  static double asin(double x) => _asin(x);
  static const double pi = 3.14159265359;

  static double _cos(double x) {
    x = x % (2 * pi);
    if (x < 0) x += 2 * pi;
    return 1 - (x * x / 2) + (x * x * x * x / 24);
  }

  static double _sin(double x) {
    x = x % (2 * pi);
    return x - (x * x * x / 6) + (x * x * x * x * x / 120);
  }

  static double _asin(double x) {
    if (x < -1 || x > 1) return 0;
    return x + (x * x * x / 6) + (3 * x * x * x * x * x / 40);
  }
}
