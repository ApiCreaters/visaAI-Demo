import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/upload_controller.dart';
import '../theme/app_colors.dart';
import 'analytics_cards.dart';
import 'result_section.dart';
import 'sidebar.dart';
import 'upload_section.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Row(
        children: [
          // ── Sidebar (hidden on mobile) ──────────────────────────────
          if (!isMobile) const Sidebar(),


          // ── Main content ────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top bar
                _TopBar(isMobile: isMobile),
                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero heading
                        _HeroHeader(isMobile: isMobile),
                        SizedBox(height: isMobile ? 16 : 20),

                        // Analytics cards
                        if (!isMobile)
                          const AnalyticsCards()
                              .animate()
                              .fadeIn(duration: 350.ms),
                        if (isMobile)
                          const _MobileAnalytics(),
                        SizedBox(height: isMobile ? 16 : 20),

                        // Main 2-column (or stacked)
                        if (isTablet || isMobile)
                          Column(
                            children: [
                              const UploadSection(),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 660,
                                child: const ResultSection(),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            height: 680,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: upload + activity
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      const UploadSection(),
                                      const SizedBox(height: 20),
                                      Expanded(child: _ActivityFeed()),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Right: results
                                Expanded(
                                  flex: 4,
                                  child: const ResultSection(),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),
                      ],
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

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isMobile;
  const _TopBar({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // decoration: const BoxDecoration(
      //   border: Border(bottom: BorderSide(color: AppColors.border)),
      // ),
      child: Row(
        children: [
          Text('Client Dashboard',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
          Text('  /  Document Checker',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textMuted,
              )),
          const Spacer(),
          // Version chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text('v2.4.1',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                )),
          ),
          const SizedBox(width: 10),
          // Notification
          _TopBarButton(
            icon: Icons.notifications_outlined,
            badge: true,
          ),
          const SizedBox(width: 8),
          _TopBarButton(icon: Icons.download_outlined),
        ],
      ),
    );
  }
}

class _TopBarButton extends StatefulWidget {
  final IconData icon;
  final bool badge;
  const _TopBarButton({required this.icon, this.badge = false});

  @override
  State<_TopBarButton> createState() => _TopBarButtonState();
}

class _TopBarButtonState extends State<_TopBarButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _hov ? const Color(0xFFF1F5F9) : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                  color: _hov ? AppColors.border : Colors.transparent),
            ),
            child: Icon(widget.icon,
                size: 18, color: AppColors.textSecondary),
          ),
          if (widget.badge)
            Positioned(
              top: 0, right: 0,
              child: Container(
                width: 9, height: 9,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final bool isMobile;
  const _HeroHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visa Document Checker AI',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: isMobile ? 22 : 28,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Document Validation for Immigration Firms',
                style: GoogleFonts.dmSans(
                  fontSize: isMobile ? 12 : 13.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text('Reduce errors by 80%',
                    style: GoogleFonts.dmSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.06, end: 0, duration: 400.ms);
  }
}

// ── Mobile Analytics (simplified 2-col) ──────────────────────────────────────
class _MobileAnalytics extends StatelessWidget {
  const _MobileAnalytics();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (ctrl) => Wrap(
        spacing: 10, runSpacing: 10,
        children: [
          _MiniStat('📁', 'Docs', ctrl.docsProcessed.toString()),
          _MiniStat('✅', 'Passed', '${ctrl.accuracyRate}%'),
          _MiniStat('⚠️', 'Errors', ctrl.errorsDetected.toString()),
          _MiniStat('⚡', 'Speed', '1.7s'),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String icon, label, value;
  const _MiniStat(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 42) / 2;
    return Container(
      width: w,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 18, color: AppColors.textPrimary)),
              Text(label,
                  style: GoogleFonts.dmSans(
                      fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Activity Feed ─────────────────────────────────────────────────────────────
class _ActivityFeed extends StatelessWidget {
  final List<_ActivityItem> _items = const [
    _ActivityItem('Priya Singh', 'Tier 4 Student Visa', 'All documents verified',
        '2 min ago', true),
    _ActivityItem('Ahmed Hassan', 'Spouse Visa', 'Missing BRP card',
        '14 min ago', false),
    _ActivityItem('Liu Wei', 'Work Permit', 'In review',
        '28 min ago', null),
    _ActivityItem('Maria Costa', 'Visitor Visa', 'All clear',
        '1 hr ago', true),
    _ActivityItem('James Okafor', 'ILR Application', 'Passport expires in 30 days',
        '2 hrs ago', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Text('Recent Activity',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.amberSoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text('Live',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amber,
                      )),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border,
                      indent: 20, endIndent: 20),
              itemBuilder: (_, i) => _ActivityTile(item: _items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String name, visa, detail, time;
  final bool? passed; // null = pending
  const _ActivityItem(this.name, this.visa, this.detail, this.time, this.passed);
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final dotColor = item.passed == null
        ? AppColors.accent
        : item.passed!
            ? AppColors.green
            : AppColors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(
                color: dotColor.withOpacity(0.4),
                blurRadius: 5,
              )],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.name} — ${item.visa}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                Text(item.detail,
                    style: GoogleFonts.dmSans(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    )),
              ],
            ),
          ),
          Text(item.time,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.textMuted,
              )),
        ],
      ),
    );
  }
}
