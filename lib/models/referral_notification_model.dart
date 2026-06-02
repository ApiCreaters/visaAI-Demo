import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralProgram {
  final String id;
  final String referrerId;
  final String referrerName;
  final String referralCode;
  final List<ReferralRedemption> redemptions;
  final int bonusPointsEarned;
  final int totalReferrals;
  final DateTime createdAt;

  ReferralProgram({
    required this.id,
    required this.referrerId,
    required this.referrerName,
    required this.referralCode,
    this.redemptions = const [],
    this.bonusPointsEarned = 0,
    this.totalReferrals = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referrerId': referrerId,
      'referrerName': referrerName,
      'referralCode': referralCode,
      'redemptions': redemptions.map((r) => r.toMap()).toList(),
      'bonusPointsEarned': bonusPointsEarned,
      'totalReferrals': totalReferrals,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReferralProgram.fromMap(Map<String, dynamic> map) {
    return ReferralProgram(
      id: map['id'] ?? '',
      referrerId: map['referrerId'] ?? '',
      referrerName: map['referrerName'] ?? '',
      referralCode: map['referralCode'] ?? '',
      redemptions: (map['redemptions'] as List<dynamic>?)
              ?.map((r) => ReferralRedemption.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      bonusPointsEarned: map['bonusPointsEarned'] ?? 0,
      totalReferrals: map['totalReferrals'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

class ReferralRedemption {
  final String id;
  final String referredUserId;
  final String referredUserName;
  final int bonusPointsPerReferrer;
  final int bonusPointsPerReferred;
  final DateTime redeemedAt;
  final String status; // 'pending', 'completed'

  ReferralRedemption({
    required this.id,
    required this.referredUserId,
    required this.referredUserName,
    this.bonusPointsPerReferrer = 100,
    this.bonusPointsPerReferred = 50,
    required this.redeemedAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referredUserId': referredUserId,
      'referredUserName': referredUserName,
      'bonusPointsPerReferrer': bonusPointsPerReferrer,
      'bonusPointsPerReferred': bonusPointsPerReferred,
      'redeemedAt': Timestamp.fromDate(redeemedAt),
      'status': status,
    };
  }

  factory ReferralRedemption.fromMap(Map<String, dynamic> map) {
    return ReferralRedemption(
      id: map['id'] ?? '',
      referredUserId: map['referredUserId'] ?? '',
      referredUserName: map['referredUserName'] ?? '',
      bonusPointsPerReferrer: map['bonusPointsPerReferrer'] ?? 100,
      bonusPointsPerReferred: map['bonusPointsPerReferred'] ?? 50,
      redeemedAt: (map['redeemedAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}

class Notification {
  final String id;
  final String userId;
  final String type; // 'location', 're-engagement', 'reward', 'new_offer'
  final String title;
  final String body;
  final String? actionUrl;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.actionUrl,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'actionUrl': actionUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      actionUrl: map['actionUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    String? actionUrl,
    DateTime? createdAt,
    bool? isRead,
    String? imageUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class AIGeneratedOffer {
  final String id;
  final String customerId;
  final String restaurantId;
  final String offerTitle;
  final String offerDescription;
  final String reason; // e.g., 'frequently visits', 'hasn't visited in 30 days'
  final int discountPercentage;
  final int pointsOffer;
  final DateTime expiryDate;
  final DateTime createdAt;
  final bool isApplied;

  AIGeneratedOffer({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.offerTitle,
    required this.offerDescription,
    required this.reason,
    this.discountPercentage = 0,
    this.pointsOffer = 0,
    required this.expiryDate,
    required this.createdAt,
    this.isApplied = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'offerTitle': offerTitle,
      'offerDescription': offerDescription,
      'reason': reason,
      'discountPercentage': discountPercentage,
      'pointsOffer': pointsOffer,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'isApplied': isApplied,
    };
  }

  factory AIGeneratedOffer.fromMap(Map<String, dynamic> map) {
    return AIGeneratedOffer(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      offerTitle: map['offerTitle'] ?? '',
      offerDescription: map['offerDescription'] ?? '',
      reason: map['reason'] ?? '',
      discountPercentage: map['discountPercentage'] ?? 0,
      pointsOffer: map['pointsOffer'] ?? 0,
      expiryDate: (map['expiryDate'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isApplied: map['isApplied'] ?? false,
    );
  }
}
