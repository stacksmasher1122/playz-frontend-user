import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QuickEventButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  QuickEventButton({
    super.key,
    required this.title,
    required this.icon,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  State<QuickEventButton> createState() => _QuickEventButtonState();
}

class _QuickEventButtonState extends State<QuickEventButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bgColor = widget.isPrimary ? AppColors.accent : Color(0xFF121212).withValues(alpha: 0.5);
    final iconColor = widget.isPrimary ? AppColors.background : Color(0xFFFFC107); // Using amber for cards/icons if not primary
    final textColor = widget.isPrimary ? AppColors.background : Colors.white;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: widget.isPrimary ? null : Border.all(color: Color(0xFF1E1E1E)),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: iconColor, size: 28),
              SizedBox(height: 8),
              Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
