import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/upload_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';

class UploadSection extends StatelessWidget {
  const UploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (ctrl) => CustomCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.upload_file_outlined,
                      color: Colors.white, size: 17),
                ),
                const SizedBox(width: 10),
                Text('Upload Documents',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                const Spacer(),
                _Chip(label: 'AI-Powered',
                    color: AppColors.accent,
                    bgColor: AppColors.accentSoft),
              ],
            ),

            const SizedBox(height: 20),

            // ── Drop Zone ─────────────────────────────────────
            _DropZone(
              isDragHovering: ctrl.isDragHovering,
              onFilePicked:   (name) => ctrl.setPassportFile(name),
              onDragHover:    (v)    => ctrl.setDragHover(v),
            ),

            const SizedBox(height: 14),

            // ── File slots ────────────────────────────────────
            _FileSlot(
              icon: '🛂',
              label: 'Passport / National ID',
              fileName: ctrl.fileName,
              required: true,
            ),
            const SizedBox(height: 8),
            _FileSlot(
              icon: '💳',
              label: 'BRP Card',
              fileName: ctrl.brpFileName,
              required: false,
              onTap: () {
                // Trigger file picker for BRP
                _openFilePicker((name) => ctrl.setBrpFile(name));
              },
            ),

            const SizedBox(height: 20),

            // ── Loading state ─────────────────────────────────
            if (ctrl.state == UploadState.loading)
              _LoadingWidget(message: ctrl.loadingMessage)
                  .animate()
                  .fadeIn(duration: 300.ms),

            // ── Analyze button ────────────────────────────────
            if (ctrl.state != UploadState.loading)
              _AnalyzeButton(
                enabled: ctrl.fileName != null &&
                    ctrl.state == UploadState.idle,
                onPressed: () => ctrl.uploadFile(),
              ),

            const SizedBox(height: 12),

            // ── Trust tagline ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Text(
                  'Reduce document errors by 80%  ·  '
                  'Powered by AI-based document intelligence',
                  style: GoogleFonts.dmSans(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _openFilePicker(void Function(String) onPicked) {
    final input = html.FileUploadInputElement()
      ..accept = '.pdf,.jpg,.jpeg,.png'
      ..click();
    input.onChange.listen((event) {
      if (input.files!.isNotEmpty) {
        onPicked(input.files!.first.name);
      }
    });
  }
}

// ── Drop Zone ─────────────────────────────────────────────────────────────────
class _DropZone extends StatelessWidget {
  final bool isDragHovering;
  final void Function(String name) onFilePicked;
  final void Function(bool) onDragHover;

  const _DropZone({
    required this.isDragHovering,
    required this.onFilePicked,
    required this.onDragHover,
  });

  void _pickFile() {
    final input = html.FileUploadInputElement()
      ..accept = '.pdf,.jpg,.jpeg,.png'
      ..click();
    input.onChange.listen((event) {
      if (input.files!.isNotEmpty) {
        onFilePicked(input.files!.first.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hov = isDragHovering;
    return MouseRegion(
      onEnter: (_) => onDragHover(true),
      onExit:  (_) => onDragHover(false),
      child: GestureDetector(
        onTap: _pickFile,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 155,
          decoration: BoxDecoration(
            color: hov ? AppColors.accentSoft : const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hov ? AppColors.accent : const Color(0xFFCBD5E1),
              width: hov ? 1.5 : 1,
              style: BorderStyle.solid,
            ),
            boxShadow: hov
                ? [BoxShadow(
                    color: AppColors.accent.withOpacity(0.12),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: hov
                      ? AppColors.accent.withOpacity(0.15)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  size: 26,
                  color: hov ? AppColors.accent : const Color(0xFF93C5FD),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                hov ? 'Drop to upload' : 'Drop your file here',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hov
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'or click to browse · PDF, JPG, PNG supported',
                style: GoogleFonts.dmSans(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TypeChip('PDF'),
                  const SizedBox(width: 6),
                  _TypeChip('JPG'),
                  const SizedBox(width: 6),
                  _TypeChip('PNG'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  const _TypeChip(this.label);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            )),
      );
}

// ── File Slot ────────────────────────────────────────────────────────────────
class _FileSlot extends StatelessWidget {
  final String  icon;
  final String  label;
  final String? fileName;
  final bool    required;
  final VoidCallback? onTap;

  const _FileSlot({
    required this.icon,
    required this.label,
    required this.fileName,
    required this.required,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: hasFile ? AppColors.greenSoft : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile
                ? AppColors.greenBorder
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.dmSans(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(
                    hasFile ? fileName! : (required ? 'Required' : 'Optional'),
                    style: GoogleFonts.dmSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: hasFile
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (hasFile)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.green, size: 18)
            else if (required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Required',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.amber,
                      fontWeight: FontWeight.w600,
                    )),
              )
            else
              const Text('Optional',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  )),
          ],
        ),
      ),
    );
  }
}

// ── Loading widget ─────────────────────────────────────────────────────────────
class _LoadingWidget extends StatelessWidget {
  final String message;
  const _LoadingWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: 48, height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.accent,
              backgroundColor: AppColors.accent.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              backgroundColor: const Color(0xFFE2E8F0),
              color: AppColors.accent,
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Analyze Button ────────────────────────────────────────────────────────────
class _AnalyzeButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const _AnalyzeButton({required this.enabled, required this.onPressed});

  @override
  State<_AnalyzeButton> createState() => _AnalyzeButtonState();
}

class _AnalyzeButtonState extends State<_AnalyzeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  )
                : null,
            color: widget.enabled ? null : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.enabled && _hovered
                ? [BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                color: widget.enabled ? Colors.white : AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Analyze Documents',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.enabled ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small Chip ────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final Color  color;
  final Color  bgColor;
  const _Chip({required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      );
}
