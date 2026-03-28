import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/upload_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';

class AnalyticsCards extends StatelessWidget {
  const AnalyticsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (ctrl) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.folder_copy_outlined,
                label: 'Docs Processed',
                value: ctrl.docsProcessed.toString(),
                delta: '+12% this week',
                deltaPositive: true,
                gradColors: [const Color(0xFF2563EB), const Color(0xFF4F46E5)],
                index: 0,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_outline_rounded,
                label: 'Checks Passed',
                value: '${ctrl.accuracyRate}%',
                delta: 'Accuracy rate',
                deltaPositive: true,
                gradColors: [const Color(0xFF16A34A), const Color(0xFF15803D)],
                index: 1,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.warning_amber_rounded,
                label: 'Errors Detected',
                value: ctrl.errorsDetected.toString(),
                delta: '▲ 3% flagged',
                deltaPositive: false,
                gradColors: [const Color(0xFFDC2626), const Color(0xFFB91C1C)],
                index: 2,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                icon: Icons.bolt_rounded,
                label: 'Avg Check Time',
                value: '1.7s',
                delta: '▼ 0.3s faster',
                deltaPositive: true,
                gradColors: [const Color(0xFF7C3AED), const Color(0xFF6D28D9)],
                index: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final String   delta;
  final bool     deltaPositive;
  final List<Color> gradColors;
  final int      index;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaPositive,
    required this.gradColors,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon + delta
          Row(
            children: [
              // Gradient icon box
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const Spacer(),
              // Delta badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: deltaPositive
                      ? AppColors.greenSoft
                      : AppColors.redSoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: deltaPositive
                        ? AppColors.greenBorder
                        : AppColors.redBorder,
                  ),
                ),
                child: Text(
                  delta,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: deltaPositive ? AppColors.green : AppColors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Value
          Text(
            value,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 30,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 4),

          // Label
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}
