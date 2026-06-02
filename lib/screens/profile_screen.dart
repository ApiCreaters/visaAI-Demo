import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_rewards/controllers/auth_controller.dart';
import 'package:wallet_rewards/controllers/user_controller.dart';

/// User profile screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.find<AuthController>();
  final userController = Get.find<UserController>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final user = userController.currentUser.value;
    if (user != null) {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile() async {
    final userId = authController.userId;
    if (userId == null) return;

    final success = await userController.updateUserProfile(
      userId: userId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneController.text,
    );

    if (success) {
      Get.snackbar('Success', 'Profile updated successfully!');
    } else {
      Get.snackbar('Error', userController.errorMessage.value);
    }
  }

  Future<void> _handleSignOut() async {
    Get.defaultDialog(
      title: 'Sign Out',
      content: const Text('Are you sure you want to sign out?'),
      onConfirm: () async {
        await authController.signOut();
        userController.clearUserData();
        Get.offNamed('/login');
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.currentUser.value;
        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  (user.firstName?.isNotEmpty == true
                      ? user.firstName!.substring(0, 1)
                      : 'U'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // User info
              Text(
                user.fullName.isNotEmpty ? user.fullName : 'User',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),

              // Edit form
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleUpdateProfile,
                  child: const Text('Update Profile'),
                ),
              ),
              const SizedBox(height: 16),

              // Account section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Email verified status
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Verified'),
                trailing: Obx(() {
                  return authController.isEmailVerified.value
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () =>
                              authController.sendEmailVerification(),
                          child: const Text('Verify'),
                        );
                }),
              ),
              const Divider(),

              // Change password
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () => Get.toNamed('/change-password'),
              ),
              const Divider(),

              // Preferences
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Preferences'),
                onTap: () => Get.toNamed('/preferences'),
              ),
              const Divider(),

              const SizedBox(height: 24),

              // Sign out button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  onPressed: _handleSignOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
