import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/loyalty_card_controller.dart';
import 'controllers/restaurant_controller.dart';
import 'controllers/upload_controller.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  await Get.putAsync<AuthService>(() async => AuthService());
  await Get.putAsync<FirebaseService>(() async => const FirebaseService());
  await Get.putAsync<LocationService>(() async {
    LocationService service = LocationService();
    await service.init();
    return service;
  });
  await Get.putAsync<NotificationService>(() async {
    NotificationService service = NotificationService();
    await service.init();
    return service;
  });

  // Initialize controllers
  Get.put(AppController());
  Get.put(AuthController());
  Get.put(LoyaltyCardController());
  Get.put(RestaurantController());
  Get.put(UploadController());

  runApp(const WalletRewardsApp());
}

class WalletRewardsApp extends StatelessWidget {
  const WalletRewardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WalletRewards – Loyalty Made Simple',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const SplashScreen(),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgPage,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}
