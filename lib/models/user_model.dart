import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerUser {
  final String id;
  final String email;
  final String phone;
  final String name;
  final String? avatar;
  final int totalPoints;
  final List<String> enrolledRestaurants;
  final List<String> redeemedRewards;
  final DateTime createdAt;
  final DateTime lastActivity;
  final String referralCode;

  CustomerUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    this.avatar,
    this.totalPoints = 0,
    this.enrolledRestaurants = const [],
    this.redeemedRewards = const [],
    required this.createdAt,
    required this.lastActivity,
    required this.referralCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'avatar': avatar,
      'totalPoints': totalPoints,
      'enrolledRestaurants': enrolledRestaurants,
      'redeemedRewards': redeemedRewards,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivity': Timestamp.fromDate(lastActivity),
      'referralCode': referralCode,
    };
  }

  factory CustomerUser.fromMap(Map<String, dynamic> map) {
    return CustomerUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'],
      totalPoints: map['totalPoints'] ?? 0,
      enrolledRestaurants: List<String>.from(map['enrolledRestaurants'] ?? []),
      redeemedRewards: List<String>.from(map['redeemedRewards'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastActivity: (map['lastActivity'] as Timestamp).toDate(),
      referralCode: map['referralCode'] ?? '',
    );
  }

  CustomerUser copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? avatar,
    int? totalPoints,
    List<String>? enrolledRestaurants,
    List<String>? redeemedRewards,
    DateTime? createdAt,
    DateTime? lastActivity,
    String? referralCode,
  }) {
    return CustomerUser(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      totalPoints: totalPoints ?? this.totalPoints,
      enrolledRestaurants: enrolledRestaurants ?? this.enrolledRestaurants,
      redeemedRewards: redeemedRewards ?? this.redeemedRewards,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      referralCode: referralCode ?? this.referralCode,
    );
  }
}
