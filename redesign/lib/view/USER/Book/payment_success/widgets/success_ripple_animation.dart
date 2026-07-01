import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class SuccessRippleAnimation extends StatelessWidget {
  final AnimationController controller;

  const SuccessRippleAnimation({
    super.key,
    required this.controller,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return Container(
                width: 120 * controller.value,
                height: 120 * controller.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kGreen.withValues(alpha: 1 - controller.value),
                ),
              );
            },
          ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _kGreen,
            ),
            child: const Icon(Icons.check, size: 36, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
