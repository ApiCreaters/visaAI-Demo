import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a loyalty transaction
class LoyaltyTransaction {
  final String id;
  final String cardId;
  final String userId;
  final String restaurantId;
  final String type; // 'earn', 'redeem', 'expire', 'adjust'
  final int pointsAmount;
  final int balanceBefore;
  final int balanceAfter;
  final String description;
  final DateTime timestamp;
  final String? rewardId;
  final double? transactionAmount;
  final Map<String, dynamic>? metadata;

  LoyaltyTransaction({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.restaurantId,
    required this.type,
    required this.pointsAmount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
    required this.timestamp,
    this.rewardId,
    this.transactionAmount,
    this.metadata,
  });

  /// Get transaction type display name
  String get typeDisplay {
    switch (type) {
      case 'earn':
        return 'Points Earned';
      case 'redeem':
        return 'Points Redeemed';
      case 'expire':
        return 'Points Expired';
      case 'adjust':
        return 'Points Adjusted';
      default:
        return type;
    }
  }

  /// Check if transaction is positive (earning points)
  bool get isPositive => type == 'earn' || type == 'adjust' && pointsAmount > 0;

  /// Convert LoyaltyTransaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardId': cardId,
      'userId': userId,
      'restaurantId': restaurantId,
      'type': type,
      'pointsAmount': pointsAmount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'rewardId': rewardId,
      'transactionAmount': transactionAmount,
      'metadata': metadata ?? {},
    };
  }

  /// Create LoyaltyTransaction from JSON
  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      type: json['type'] as String,
      pointsAmount: json['pointsAmount'] as int,
      balanceBefore: json['balanceBefore'] as int,
      balanceAfter: json['balanceAfter'] as int,
      description: json['description'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      rewardId: json['rewardId'] as String?,
      transactionAmount: (json['transactionAmount'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Copy with modified fields
  LoyaltyTransaction copyWith({
    String? id,
    String? cardId,
    String? userId,
    String? restaurantId,
    String? type,
    int? pointsAmount,
    int? balanceBefore,
    int? balanceAfter,
    String? description,
    DateTime? timestamp,
    String? rewardId,
    double? transactionAmount,
    Map<String, dynamic>? metadata,
  }) {
    return LoyaltyTransaction(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      type: type ?? this.type,
      pointsAmount: pointsAmount ?? this.pointsAmount,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      rewardId: rewardId ?? this.rewardId,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      metadata: metadata ?? this.metadata,
    );
  }
}
