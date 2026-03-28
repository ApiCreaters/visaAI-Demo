import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/upload_controller.dart';
import 'views/dashboard_view.dart';

void main() {
  runApp(const VisaAIApp());
}

class VisaAIApp extends StatelessWidget {
  const VisaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controller globally (Get.put equivalent)
    Get.put(UploadController());

    return GetMaterialApp(
      title: 'VisaAI – Document Intelligence',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const DashboardView(),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF0F4F8),
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
