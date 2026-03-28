import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class ChecklistItem extends StatelessWidget {
  final String label;
  final String icon;
  final bool   passed;
  final int    index; // for staggered animation delay

  const ChecklistItem({
    super.key,
    required this.label,
    required this.icon,
    required this.passed,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color  = passed ? AppColors.green : AppColors.red;
    final bgSoft = passed ? AppColors.greenSoft : AppColors.redSoft;
    final bdClr  = passed ? AppColors.greenBorder : AppColors.redBorder;
    final statusLabel = passed ? 'VERIFIED' : 'MISSING';
    final statusIcon  = passed ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bgSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bdClr, width: 1),
      ),
      child: Row(
        children: [
          // Emoji icon
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05, end: 0, duration: 300.ms);
  }
}
