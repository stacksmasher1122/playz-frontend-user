import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SuccessRippleAnimation extends StatelessWidget {
  final AnimationController controller;

  const SuccessRippleAnimation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = context.minDimensionPct(28).clamp(100.0, 130.0);
    final centerCircleSize = context.minDimensionPct(15).clamp(56.0, 72.0);

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return Container(
                width: size * controller.value,
                height: size * controller.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 1 - controller.value),
                ),
              );
            },
          ),
          Container(
            width: centerCircleSize,
            height: centerCircleSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
            child: const Icon(Icons.check, size: 36, color: AppColors.background),
          ),
        ],
      ),
    );
  }
}
