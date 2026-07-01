import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPrimary; // true for Team A (neon), false for Team B (dark)

  PointButton({super.key, required this.onPressed, this.isPrimary = true});

  @override
  State<PointButton> createState() => _PointButtonState();
}

class _PointButtonState extends State<PointButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isPrimary ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: widget.isPrimary ? Colors.transparent : AppColors.surfaceContainerHighest),
            boxShadow: widget.isPrimary
                ? [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ADD POINT',
                style: AppTypography.labelCaps10.copyWith(
                  color: widget.isPrimary ? Colors.black54 : AppColors.primaryContainer,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '+1',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(80),
                  fontWeight: FontWeight.w900,
                  color: widget.isPrimary ? Colors.black : AppColors.primaryContainer,
                  height: ResponsiveHelper.h(1),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bolt,
                    color: widget.isPrimary ? Colors.black54 : AppColors.surfaceContainerHighest,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'TAP TO SCORE',
                    style: AppTypography.labelCaps10.copyWith(
                      color: widget.isPrimary ? Colors.black54 : AppColors.surfaceContainerHighest,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
