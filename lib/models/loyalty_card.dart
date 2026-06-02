import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a loyalty card
class LoyaltyCard {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String cardNumber;
  final int currentPoints;
  final int totalPointsEarned;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final bool isActive;
  final String? qrCode;
  final Map<String, dynamic>? metadata;

  LoyaltyCard({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.cardNumber,
    this.currentPoints = 0,
    this.totalPointsEarned = 0,
    required this.createdAt,
    this.lastUsedAt,
    this.isActive = true,
    this.qrCode,
    this.metadata,
  });

  /// Convert LoyaltyCard to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'cardNumber': cardNumber,
      'currentPoints': currentPoints,
      'totalPointsEarned': totalPointsEarned,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUsedAt': lastUsedAt != null ? Timestamp.fromDate(lastUsedAt!) : null,
      'isActive': isActive,
      'qrCode': qrCode,
      'metadata': metadata ?? {},
    };
  }

  /// Create LoyaltyCard from JSON
  factory LoyaltyCard.fromJson(Map<String, dynamic> json) {
    return LoyaltyCard(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      cardNumber: json['cardNumber'] as String,
      currentPoints: json['currentPoints'] as int? ?? 0,
      totalPointsEarned: json['totalPointsEarned'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastUsedAt: json['lastUsedAt'] != null
          ? (json['lastUsedAt'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] as bool? ?? true,
      qrCode: json['qrCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Copy with modified fields
  LoyaltyCard copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? cardNumber,
    int? currentPoints,
    int? totalPointsEarned,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    bool? isActive,
    String? qrCode,
    Map<String, dynamic>? metadata,
  }) {
    return LoyaltyCard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      cardNumber: cardNumber ?? this.cardNumber,
      currentPoints: currentPoints ?? this.currentPoints,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      isActive: isActive ?? this.isActive,
      qrCode: qrCode ?? this.qrCode,
      metadata: metadata ?? this.metadata,
    );
  }
}
