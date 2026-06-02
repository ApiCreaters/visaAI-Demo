import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_rewards/controllers/auth_controller.dart';
import 'package:wallet_rewards/controllers/loyalty_controller.dart';
import 'package:wallet_rewards/controllers/user_controller.dart';

/// Home/Dashboard screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final loyaltyController = Get.find<LoyaltyController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (authController.userId != null) {
      await loyaltyController.getUserLoyaltyCards(authController.userId!);
      await userController.loadUserProfile(authController.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletRewards'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Obx(() {
                final user = userController.currentUser.value;
                return Text(
                  'Hello, ${user?.firstName ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              }),
              const SizedBox(height: 24),

              // Total points section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Points',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final totalPoints = loyaltyController.getTotalPoints();
                      return Text(
                        totalPoints.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Loyalty cards section
              Text(
                'Your Cards',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (loyaltyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cards = loyaltyController.loyaltyCards;
                if (cards.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No loyalty cards yet'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Get.toNamed('/browse-restaurants'),
                          child: const Text('Browse Restaurants'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _buildCardItem(context, card);
                  },
                );
              }),
              const SizedBox(height: 32),

              // Add card button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Card'),
                  onPressed: () => Get.toNamed('/browse-restaurants'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Rewards'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_2), label: 'QR'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Get.toNamed('/rewards');
              break;
            case 2:
              Get.toNamed('/qr-scanner');
              break;
            case 3:
              Get.toNamed('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, dynamic card) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.card_membership),
        title: Text(card.restaurantName),
        subtitle: Text('Points: ${card.currentPoints}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          loyaltyController.selectCard(card);
          Get.toNamed('/card-details');
        },
      ),
    );
  }
}
