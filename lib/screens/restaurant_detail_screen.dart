import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/restaurant_controller.dart';
import '../controllers/loyalty_card_controller.dart';
import '../theme/app_colors.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final dynamic restaurant;

  const RestaurantDetailScreen({required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late RestaurantController _restaurantCtrl;
  late LoyaltyCardController _cardCtrl;
  bool _isEnrolling = false;

  @override
  void initState() {
    super.initState();
    _restaurantCtrl = Get.find<RestaurantController>();
    _cardCtrl = Get.find<LoyaltyCardController>();
    _restaurantCtrl.selectRestaurant(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    bool isEnrolled = _restaurantCtrl.isEnrolled(widget.restaurant);
    var card = _restaurantCtrl.getLoyaltyCard(widget.restaurant);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGrad,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant name and info
                      Text(
                        widget.restaurant.restaurantName,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.restaurant.address,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Points info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Points per Visit',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.restaurant.pointsPerVisit} pts',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                            if (isEnrolled && card != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Your Points',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${card.currentPoints}',
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Enroll button (if not enrolled)
                      if (!isEnrolled)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() => _isEnrolling = true);
                              bool success =
                                  await _cardCtrl.enrollInRestaurant(
                                widget.restaurant,
                              );
                              setState(() => _isEnrolling = false);
                              if (success) {
                                Get.snackbar(
                                  'Success',
                                  'You have enrolled in ${widget.restaurant.restaurantName}',
                                  backgroundColor: AppColors.greenSoft,
                                  colorText: AppColors.green,
                                );
                                setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isEnrolling
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Enroll Now',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Rewards section
                      Text(
                        'Available Rewards',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (widget.restaurant.rewards.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No rewards available yet',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.restaurant.rewards.length,
                          itemBuilder: (context, index) {
                            var reward = widget.restaurant.rewards[index];
                            bool canRedeem = isEnrolled &&
                                card != null &&
                                card.currentPoints >= reward.pointsRequired;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: canRedeem
                                      ? AppColors.green
                                      : AppColors.border,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reward.title,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              reward.description,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: canRedeem
                                              ? AppColors.greenSoft
                                              : AppColors.accentSoft,
                                          border: Border.all(
                                            color: canRedeem
                                                ? AppColors.greenBorder
                                                : const Color(0xFFBFDBFE),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${reward.pointsRequired} pts',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: canRedeem
                                                ? AppColors.green
                                                : AppColors.accent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (canRedeem) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          bool success = await _cardCtrl
                                              .redeemReward(card.id, reward);
                                          if (success) {
                                            Get.snackbar(
                                              'Success',
                                              'Reward redeemed!',
                                              backgroundColor:
                                                  AppColors.greenSoft,
                                              colorText: AppColors.green,
                                            );
                                            setState(() {});
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Redeem',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
