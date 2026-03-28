import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/upload_controller.dart';
import '../theme/app_colors.dart';

class _NavItem {
  final IconData icon;
  final String   label;
  final String?  badge;
  const _NavItem(this.icon, this.label, {this.badge});
}

final _navItems = [
  const _NavItem(Icons.grid_view_rounded, 'Dashboard'),
  const _NavItem(Icons.description_outlined, 'Documents', badge: 'New'),
  const _NavItem(Icons.analytics_outlined, 'Analytics'),
  const _NavItem(Icons.people_outline_rounded, 'Clients'),
  const _NavItem(Icons.settings_outlined, 'Settings'),
];

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (ctrl) => Container(
        width: 230,
        color: AppColors.bgSidebar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Logo ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo mark
                  Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Text('V', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          )),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'VisaAI',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Document Intelligence',
                    style: GoogleFonts.dmSans(
                      fontSize: 10.5,
                      color: AppColors.textSidebarM,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFF1E293B), height: 1),

            const SizedBox(height: 12),

            // ── Nav section label ─────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 6),
              child: Text(
                'MAIN MENU',
                style: GoogleFonts.dmSans(
                  fontSize: 9.5,
                  color: AppColors.textSidebarM,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                ),
              ),
            ),

            // ── Nav items ─────────────────────────────────────
            ..._navItems.asMap().entries.map((entry) {
              final i    = entry.key;
              final item = entry.value;
              return _SidebarNavTile(
                icon:      item.icon,
                label:     item.label,
                badge:     item.badge,
                isActive:  ctrl.activeNavIndex == i,
                onTap:     () => ctrl.setNavIndex(i),
              );
            }),

            const Spacer(),

            const Divider(color: Color(0xFF1E293B), height: 1),

            // ── User card ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text('SA', style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sarah Ahmed',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              )),
                          Text('Senior Consultant',
                              style: GoogleFonts.dmSans(
                                color: AppColors.textSidebarM,
                                fontSize: 10.5,
                              )),
                        ],
                      ),
                    ),
                    // Online indicator
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: const Color(0xFF22C55E).withOpacity(0.5),
                          blurRadius: 6,
                        )],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarNavTile extends StatefulWidget {
  final IconData icon;
  final String   label;
  final String?  badge;
  final bool     isActive;
  final VoidCallback onTap;

  const _SidebarNavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  State<_SidebarNavTile> createState() => _SidebarNavTileState();
}

class _SidebarNavTileState extends State<_SidebarNavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    final tileColor = isActive
        ? AppColors.sidebarActive.withOpacity(0.3)
        : _hovered
            ? const Color(0xFF1E293B)
            : Colors.transparent;
    final textColor = isActive
        ? Colors.white
        : _hovered
            ? AppColors.textSidebar
            : AppColors.textSidebarM;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(color: AppColors.accent.withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              // Active indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 3,
                height: isActive ? 18 : 0,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (isActive) const SizedBox(width: 8),
              Icon(widget.icon,
                size: 18,
                color: isActive ? Colors.white : textColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
