import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ServingIndicator extends StatefulWidget {
  final bool isServingLeft;
  final AnimationController pulseController;

  const ServingIndicator({
    super.key,
    required this.isServingLeft,
    required this.pulseController,
  });

  @override
  State<ServingIndicator> createState() => _ServingIndicatorState();
}

class _ServingIndicatorState extends State<ServingIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: widget.isServingLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1.0).animate(widget.pulseController),
            child: const Icon(Icons.radio_button_checked, color: AppColors.primaryContainer, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            'SERVING',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
