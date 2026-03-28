import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A premium card with hover elevation effect (works on Web)
class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool hoverable;
  final double elevation;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.hoverable = true,
    this.elevation = 0,
    this.border,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _elevation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.hoverable) return;
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        if (!widget.hoverable) return;
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _elevation,
        builder: (context, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.bgCard,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            border: widget.border ??
                Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                    _hovered ? 0.08 : 0.04),
                blurRadius: _hovered ? 24 : 8,
                offset: Offset(0, _hovered ? 8 : 2),
              ),
            ],
          ),
          child: child,
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(24),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
