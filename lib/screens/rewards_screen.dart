import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_rewards/controllers/loyalty_controller.dart';

/// Rewards screen
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final loyaltyController = Get.find<LoyaltyController>();

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final selectedCard = loyaltyController.selectedCard.value;
    if (selectedCard != null) {
      await loyaltyController.getRestaurantRewards(selectedCard.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rewards'),
      ),
      body: Obx(() {
        if (loyaltyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final rewards = loyaltyController.availableRewards;
        final currentPoints = loyaltyController.selectedCard.value?.currentPoints ?? 0;

        if (rewards.isEmpty) {
          return const Center(
            child: Text('No rewards available'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            final reward = rewards[index];
            final canRedeem = currentPoints >= reward.pointsRequired;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reward.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${reward.pointsRequired} points',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: canRedeem
                              ? () => _handleRedemption(reward)
                              : null,
                          child: const Text('Redeem'),
                        ),
                      ],
                    ),
                    if (!canRedeem)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Need ${reward.pointsRequired - currentPoints} more points',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _handleRedemption(dynamic reward) {
    final selectedCard = loyaltyController.selectedCard.value;
    if (selectedCard == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Text(
          'Redeem "${reward.title}" for ${reward.pointsRequired} points?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              loyaltyController.updateCardPoints(
                card: selectedCard,
                pointsChange: -reward.pointsRequired,
                rewardId: reward.id,
                description: reward.title,
              );
              Navigator.pop(context);
              Get.snackbar('Success', 'Reward redeemed successfully!');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
