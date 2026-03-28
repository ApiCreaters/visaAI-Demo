import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgPage     = Color(0xFFF0F4F8);
  static const Color bgSidebar  = Color(0xFF0F172A);
  static const Color bgCard     = Colors.white;
  static const Color bgCardHov  = Color(0xFFF8FAFF);

  // Borders
  static const Color border     = Color(0xFFE2E8F0);
  static const Color borderFocus= Color(0xFF2563EB);

  // Text
  static const Color textPrimary  = Color(0xFF0F172A);
  static const Color textSecondary= Color(0xFF64748B);
  static const Color textMuted    = Color(0xFF94A3B8);
  static const Color textSidebar  = Color(0xFFCBD5E1);
  static const Color textSidebarM = Color(0xFF64748B);

  // Accent
  static const Color accent     = Color(0xFF2563EB);
  static const Color accentSoft = Color(0xFFEFF6FF);
  static const Color accent2    = Color(0xFF7C3AED);

  // Status
  static const Color green      = Color(0xFF16A34A);
  static const Color greenSoft  = Color(0xFFF0FDF4);
  static const Color greenBorder= Color(0xFFBBF7D0);
  static const Color red        = Color(0xFFDC2626);
  static const Color redSoft    = Color(0xFFFEF2F2);
  static const Color redBorder  = Color(0xFFFECACA);
  static const Color amber      = Color(0xFFD97706);
  static const Color amberSoft  = Color(0xFFFFFBEB);

  // Sidebar active
  static const Color sidebarActive     = Color(0xFF1E40AF);
  static const Color sidebarActiveSoft = Color(0xFF1D4ED8);

  // Gradient
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
    begin: Alignment.centerLeft,
    end:   Alignment.centerRight,
  );

  static const LinearGradient cardTopGrad = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end:   Alignment.bottomRight,
  );
}

class AppText {
  AppText._();

  static TextStyle displayLarge(BuildContext ctx) =>
      GoogleFonts.dmSerifDisplay(
        fontSize: 28, fontWeight: FontWeight.w400,
        color: AppColors.textPrimary, letterSpacing: -0.5,
      );

  static TextStyle headingMd(BuildContext ctx) =>
      GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle headingSm(BuildContext ctx) =>
      GoogleFonts.dmSans(
        fontSize: 13.5, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle body(BuildContext ctx) =>
      GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle label(BuildContext ctx) =>
      GoogleFonts.dmSans(
        fontSize: 10.5, fontWeight: FontWeight.w600,
        color: AppColors.textMuted, letterSpacing: 1.2,
      );

  static TextStyle mono(BuildContext ctx) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
}
