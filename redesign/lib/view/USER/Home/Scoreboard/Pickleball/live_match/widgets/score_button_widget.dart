import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreButtonWidget extends StatefulWidget {
  final String teamName;
  final VoidCallback onTap;
  final bool isActive;

  ScoreButtonWidget({
    super.key,
    required this.teamName,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<ScoreButtonWidget> createState() => _ScoreButtonWidgetState();
}

class _ScoreButtonWidgetState extends State<ScoreButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: ResponsiveHelper.h(140),
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
          decoration: BoxDecoration(
            color: widget.isActive ? AppColors.accent : AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: widget.isActive ? AppColors.accent : AppColors.outlineVariant, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.teamName,
                style: AppTypography.labelCaps10.copyWith(
                  color: widget.isActive ? Colors.black.withOpacity(0.7) : AppColors.muted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '+1',
                style: AppTypography.displayMd.copyWith(
                  color: widget.isActive ? Colors.black : AppColors.accent,
                  fontWeight: FontWeight.w900,
                  height: ResponsiveHelper.h(1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
