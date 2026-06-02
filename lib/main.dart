import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:wallet_rewards/services/firebase_service.dart';
import 'package:wallet_rewards/services/storage_service.dart';
import 'package:wallet_rewards/controllers/auth_controller.dart';
import 'package:wallet_rewards/controllers/loyalty_controller.dart';
import 'package:wallet_rewards/controllers/qr_controller.dart';
import 'package:wallet_rewards/controllers/user_controller.dart';
import 'package:wallet_rewards/screens/home_screen.dart';
import 'package:wallet_rewards/screens/login_screen.dart';
import 'package:wallet_rewards/screens/qr_scanner_screen.dart';
import 'package:wallet_rewards/screens/rewards_screen.dart';
import 'package:wallet_rewards/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.initialize();
  
  // Initialize Storage Service
  await StorageService().init();
  
  // Initialize GetX Controllers
  Get.put(AuthController());
  Get.put(LoyaltyController());
  Get.put(QrController());
  Get.put(UserController());

  runApp(const WalletRewardsApp());
}

class WalletRewardsApp extends StatelessWidget {
  const WalletRewardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'WalletRewards',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      getPages: _buildGetPages(),
      home: Obx(() {
        // Show login if not authenticated, home if authenticated
        return authController.isAuthenticated ? const HomeScreen() : const LoginScreen();
      }),
    );
  }

  /// Build theme for the app
  ThemeData _buildTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade50,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Build GetX pages/routes
  List<GetPage> _buildGetPages() {
    return [
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: '/home',
        page: () => const HomeScreen(),
      ),
      GetPage(
        name: '/qr-scanner',
        page: () => const QrScannerScreen(),
      ),
      GetPage(
        name: '/rewards',
        page: () => const RewardsScreen(),
      ),
      GetPage(
        name: '/profile',
        page: () => const ProfileScreen(),
      ),
    ];
  }
}

