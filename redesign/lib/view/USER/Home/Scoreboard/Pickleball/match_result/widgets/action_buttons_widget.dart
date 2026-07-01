import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onReturn;
  final VoidCallback onShare;

  ActionButtonsWidget({
    super.key,
    required this.onReturn,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        _ActionButton(
          label: 'Return to Dashboard',
          onTap: onReturn,
          isPrimary: true,
        ),
        SizedBox(height: 12),
        _ActionButton(
          label: 'Share Results',
          onTap: onShare,
          isPrimary: false,
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  _ActionButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> with SingleTickerProviderStateMixin {
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
        scale: Tween<double>(begin: 1.0, end: 0.97).animate(_scaleController),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: widget.isPrimary ? AppColors.primaryContainer : AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: widget.isPrimary ? null : Border.all(color: AppColors.surfaceContainerHighest, width: 1),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: AppTypography.headlineMd.copyWith(
                color: widget.isPrimary ? Colors.black : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
