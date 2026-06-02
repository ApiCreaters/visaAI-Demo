import 'package:wallet_rewards/models/loyalty_card.dart';
import 'package:wallet_rewards/models/loyalty_transaction.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

/// Loyalty service for business logic and points calculations
class LoyaltyService {
  static final LoyaltyService _instance = LoyaltyService._internal();

  factory LoyaltyService() {
    return _instance;
  }

  LoyaltyService._internal();

  static const uuid = Uuid();

  /// Calculate points from transaction amount
  /// Default: 1 point per unit of currency
  int calculatePointsFromAmount(double amount, {double pointsPerUnit = 1.0}) {
    return (amount * pointsPerUnit).toInt();
  }

  /// Generate unique card number
  String generateCardNumber(String restaurantPrefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = uuid.v1().replaceAll('-', '').substring(0, 8);
    return '$restaurantPrefix-${timestamp.toString().substring(5)}-$random';
  }

  /// Create points transaction
  LoyaltyTransaction createEarnTransaction({
    required String cardId,
    required String userId,
    required String restaurantId,
    required int pointsEarned,
    required int currentBalance,
    double? transactionAmount,
  }) {
    final newBalance = currentBalance + pointsEarned;
    return LoyaltyTransaction(
      id: uuid.v4(),
      cardId: cardId,
      userId: userId,
      restaurantId: restaurantId,
      type: 'earn',
      pointsAmount: pointsEarned,
      balanceBefore: currentBalance,
      balanceAfter: newBalance,
      description: 'Points earned from purchase',
      timestamp: DateTime.now(),
      transactionAmount: transactionAmount,
    );
  }

  /// Create redemption transaction
  LoyaltyTransaction createRedeemTransaction({
    required String cardId,
    required String userId,
    required String restaurantId,
    required String rewardId,
    required int pointsRedeemed,
    required int currentBalance,
    required String rewardTitle,
  }) {
    final newBalance = currentBalance - pointsRedeemed;
    return LoyaltyTransaction(
      id: uuid.v4(),
      cardId: cardId,
      userId: userId,
      restaurantId: restaurantId,
      type: 'redeem',
      pointsAmount: pointsRedeemed,
      balanceBefore: currentBalance,
      balanceAfter: newBalance,
      description: 'Points redeemed for: $rewardTitle',
      timestamp: DateTime.now(),
      rewardId: rewardId,
    );
  }

  /// Calculate points expiry
  DateTime calculateExpiryDate({
    Duration expiryDuration = const Duration(days: 365),
  }) {
    return DateTime.now().add(expiryDuration);
  }

  /// Check if points are expired
  bool arePointsExpired(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate);
  }

  /// Format points for display
  String formatPoints(int points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1)}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }

  /// Get points tier based on total earned
  String getPointsTier(int totalPointsEarned) {
    if (totalPointsEarned >= 10000) return 'Platinum';
    if (totalPointsEarned >= 5000) return 'Gold';
    if (totalPointsEarned >= 2000) return 'Silver';
    if (totalPointsEarned >= 500) return 'Bronze';
    return 'Member';
  }

  /// Calculate tier progress percentage
  double getTierProgressPercentage(int totalPointsEarned) {
    const bronzeTier = 500;
    const silverTier = 2000;
    const goldTier = 5000;
    const platinumTier = 10000;

    if (totalPointsEarned >= platinumTier) return 100.0;
    if (totalPointsEarned >= goldTier) {
      return ((totalPointsEarned - goldTier) / (platinumTier - goldTier)) * 100;
    }
    if (totalPointsEarned >= silverTier) {
      return ((totalPointsEarned - silverTier) / (goldTier - silverTier)) * 100;
    }
    if (totalPointsEarned >= bronzeTier) {
      return ((totalPointsEarned - bronzeTier) / (silverTier - bronzeTier)) * 100;
    }
    return (totalPointsEarned / bronzeTier) * 100;
  }

  /// Get next tier threshold
  int getNextTierThreshold(int totalPointsEarned) {
    if (totalPointsEarned < 500) return 500;
    if (totalPointsEarned < 2000) return 2000;
    if (totalPointsEarned < 5000) return 5000;
    if (totalPointsEarned < 10000) return 10000;
    return totalPointsEarned;
  }

  /// Format date for display
  String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Calculate days until expiry
  int? daysUntilExpiry(DateTime? expiryDate) {
    if (expiryDate == null) return null;
    final difference = expiryDate.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Get expiry status text
  String getExpiryStatusText(DateTime? expiryDate) {
    if (expiryDate == null) return 'Never expires';
    
    final daysLeft = daysUntilExpiry(expiryDate);
    if (daysLeft == null || daysLeft < 0) return 'Expired';
    if (daysLeft == 0) return 'Expires today';
    if (daysLeft == 1) return 'Expires tomorrow';
    if (daysLeft <= 30) return 'Expires in $daysLeft days';
    
    return 'Expires ${formatDate(expiryDate)}';
  }
}
