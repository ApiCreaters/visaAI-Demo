import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyCard {
  final String id;
  final String customerId;
  final String restaurantId;
  final String restaurantName;
  final int currentPoints;
  final List<PointsTransaction> transactions;
  final List<RedeemedReward> redeemedRewards;
  final DateTime enrolledAt;
  final DateTime lastPointsEarned;
  final String barcode;

  LoyaltyCard({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    this.currentPoints = 0,
    this.transactions = const [],
    this.redeemedRewards = const [],
    required this.enrolledAt,
    required this.lastPointsEarned,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'currentPoints': currentPoints,
      'transactions': transactions.map((t) => t.toMap()).toList(),
      'redeemedRewards': redeemedRewards.map((r) => r.toMap()).toList(),
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'lastPointsEarned': Timestamp.fromDate(lastPointsEarned),
      'barcode': barcode,
    };
  }

  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    return LoyaltyCard(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      currentPoints: map['currentPoints'] ?? 0,
      transactions: (map['transactions'] as List<dynamic>?)
              ?.map((t) => PointsTransaction.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [],
      redeemedRewards: (map['redeemedRewards'] as List<dynamic>?)
              ?.map((r) => RedeemedReward.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      enrolledAt: (map['enrolledAt'] as Timestamp).toDate(),
      lastPointsEarned: (map['lastPointsEarned'] as Timestamp).toDate(),
      barcode: map['barcode'] ?? '',
    );
  }

  LoyaltyCard copyWith({
    String? id,
    String? customerId,
    String? restaurantId,
    String? restaurantName,
    int? currentPoints,
    List<PointsTransaction>? transactions,
    List<RedeemedReward>? redeemedRewards,
    DateTime? enrolledAt,
    DateTime? lastPointsEarned,
    String? barcode,
  }) {
    return LoyaltyCard(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      currentPoints: currentPoints ?? this.currentPoints,
      transactions: transactions ?? this.transactions,
      redeemedRewards: redeemedRewards ?? this.redeemedRewards,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      lastPointsEarned: lastPointsEarned ?? this.lastPointsEarned,
      barcode: barcode ?? this.barcode,
    );
  }
}

class PointsTransaction {
  final String id;
  final int points;
  final String type; // 'earned', 'redeemed', 'expired'
  final String description;
  final DateTime timestamp;

  PointsTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'points': points,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory PointsTransaction.fromMap(Map<String, dynamic> map) {
    return PointsTransaction(
      id: map['id'] ?? '',
      points: map['points'] ?? 0,
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  PointsTransaction copyWith({
    String? id,
    int? points,
    String? type,
    String? description,
    DateTime? timestamp,
  }) {
    return PointsTransaction(
      id: id ?? this.id,
      points: points ?? this.points,
      type: type ?? this.type,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class RedeemedReward {
  final String id;
  final String rewardId;
  final String rewardTitle;
  final int pointsUsed;
  final DateTime redeemedAt;
  final String? code; // unique redemption code
  final String status; // 'redeemed', 'used', 'expired'

  RedeemedReward({
    required this.id,
    required this.rewardId,
    required this.rewardTitle,
    required this.pointsUsed,
    required this.redeemedAt,
    this.code,
    this.status = 'redeemed',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rewardId': rewardId,
      'rewardTitle': rewardTitle,
      'pointsUsed': pointsUsed,
      'redeemedAt': Timestamp.fromDate(redeemedAt),
      'code': code,
      'status': status,
    };
  }

  factory RedeemedReward.fromMap(Map<String, dynamic> map) {
    return RedeemedReward(
      id: map['id'] ?? '',
      rewardId: map['rewardId'] ?? '',
      rewardTitle: map['rewardTitle'] ?? '',
      pointsUsed: map['pointsUsed'] ?? 0,
      redeemedAt: (map['redeemedAt'] as Timestamp).toDate(),
      code: map['code'],
      status: map['status'] ?? 'redeemed',
    );
  }

  RedeemedReward copyWith({
    String? id,
    String? rewardId,
    String? rewardTitle,
    int? pointsUsed,
    DateTime? redeemedAt,
    String? code,
    String? status,
  }) {
    return RedeemedReward(
      id: id ?? this.id,
      rewardId: rewardId ?? this.rewardId,
      rewardTitle: rewardTitle ?? this.rewardTitle,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      code: code ?? this.code,
      status: status ?? this.status,
    );
  }
}
