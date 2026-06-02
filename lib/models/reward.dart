import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a reward
class Reward {
  final String id;
  final String restaurantId;
  final String title;
  final String description;
  final int pointsRequired;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? expiryDate;
  final bool isAvailable;
  final int totalAvailable;
  final int claimedCount;
  final String? category;
  final Map<String, dynamic>? details;

  Reward({
    required this.id,
    required this.restaurantId,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.imageUrl,
    required this.createdAt,
    this.expiryDate,
    this.isAvailable = true,
    this.totalAvailable = -1,
    this.claimedCount = 0,
    this.category,
    this.details,
  });

  /// Check if reward is still valid
  bool get isValid {
    if (!isAvailable) return false;
    if (expiryDate != null && DateTime.now().isAfter(expiryDate!)) return false;
    if (totalAvailable > 0 && claimedCount >= totalAvailable) return false;
    return true;
  }

  /// Convert Reward to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'title': title,
      'description': description,
      'pointsRequired': pointsRequired,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'isAvailable': isAvailable,
      'totalAvailable': totalAvailable,
      'claimedCount': claimedCount,
      'category': category,
      'details': details ?? {},
    };
  }

  /// Create Reward from JSON
  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      pointsRequired: json['pointsRequired'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      expiryDate: json['expiryDate'] != null
          ? (json['expiryDate'] as Timestamp).toDate()
          : null,
      isAvailable: json['isAvailable'] as bool? ?? true,
      totalAvailable: json['totalAvailable'] as int? ?? -1,
      claimedCount: json['claimedCount'] as int? ?? 0,
      category: json['category'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  /// Copy with modified fields
  Reward copyWith({
    String? id,
    String? restaurantId,
    String? title,
    String? description,
    int? pointsRequired,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? expiryDate,
    bool? isAvailable,
    int? totalAvailable,
    int? claimedCount,
    String? category,
    Map<String, dynamic>? details,
  }) {
    return Reward(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
      isAvailable: isAvailable ?? this.isAvailable,
      totalAvailable: totalAvailable ?? this.totalAvailable,
      claimedCount: claimedCount ?? this.claimedCount,
      category: category ?? this.category,
      details: details ?? this.details,
    );
  }
}
