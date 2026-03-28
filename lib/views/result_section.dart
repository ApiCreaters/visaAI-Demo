import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/upload_controller.dart' hide ChecklistItem;
import '../theme/app_colors.dart';
import '../widgets/checklist_item.dart';
import '../widgets/custom_card.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (ctrl) {
        if (ctrl.state == UploadState.idle) {
          return _IdlePlaceholder();
        }
        if (ctrl.state == UploadState.loading) {
          return _LoadingPlaceholder();
        }
        // Result state
        return _ResultCard(ctrl: ctrl)
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.05, end: 0, duration: 400.ms, curve: Curves.easeOut);
      },
    );
  }
}

// ── Idle placeholder ──────────────────────────────────────────────────────────
class _IdlePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hoverable: false,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 34,
                color: Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 16),
            Text('AI Results Panel',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                )),
            const SizedBox(height: 6),
            Text(
              'Upload a document and tap Analyze\nto see the AI-extracted results.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 12.5,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading placeholder ───────────────────────────────────────────────────────
class _LoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hoverable: false,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56, height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.accent,
                backgroundColor: AppColors.accent.withOpacity(0.08),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: GetNumUtils(1.2).seconds),
            const SizedBox(height: 18),
            Text('Processing…',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Result card ───────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final UploadController ctrl;
  const _ResultCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final r = ctrl.result!;
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return CustomCard(
      padding: EdgeInsets.zero,
      hoverable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Success header ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.greenBorder),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded,
                    color: AppColors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'AI Analysis Complete',
                  style: GoogleFonts.dmSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.greenBorder),
                  ),
                  child: Text(timeStr,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),

          // ── Extracted data grid ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EXTRACTED DATA',
                    style: GoogleFonts.dmSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    )),
                const SizedBox(height: 12),

                // 2×2 data grid
                Row(
                  children: [
                    Expanded(
                      child: _DataField(
                          label: 'Full Name',
                          value: r.name,
                          valueColor: AppColors.accent),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _DataField(
                          label: 'Nationality',
                          value: r.nationality),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _DataField(
                          label: 'Visa Type',
                          value: r.visaType,
                          valueColor: AppColors.amber),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _DataField(
                          label: 'Expiry Date',
                          value: r.expiryDate,
                          valueColor: AppColors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _DataField(
                  label: 'Document Number',
                  value: r.documentNumber,
                  mono: true,
                ),

                const SizedBox(height: 18),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Checklist ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('REQUIRED DOCUMENTS',
                    style: GoogleFonts.dmSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    )),
                const SizedBox(height: 10),
                ...r.checklist.asMap().entries.map((e) => ChecklistItem(
                      label:  e.value.label,
                      icon:   e.value.icon,
                      passed: e.value.passed,
                      index:  e.key,
                    )),
              ],
            ),
          ),

          // ── Action buttons ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                // New check
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ctrl.reset(),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('New Check'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Save report
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Save Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
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

// ── Data field ────────────────────────────────────────────────────────────────
class _DataField extends StatelessWidget {
  final String  label;
  final String  value;
  final Color?  valueColor;
  final bool    mono;

  const _DataField({
    required this.label,
    required this.value,
    this.valueColor,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            )),
        const SizedBox(height: 4),
        if (mono)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(value,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                )),
          )
        else
          Text(value,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimary,
              )),
      ],
    );
  }
}
