import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;

class PaymentRippleEffect extends StatelessWidget {
  final AnimationController controller;
  final double baseSize;

  const PaymentRippleEffect({
    super.key,
    required this.controller,
    this.baseSize = 96,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final value = controller.value;

        final double rippleSize = baseSize + (value * 80);
        final double opacity = (1 - value).clamp(0.0, 1.0);

        return Container(
          width: rippleSize,
          height: rippleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: kGreen.withOpacity(0.35 * opacity),
              width: 2.5,
            ),
          ),
        );
      },
    );
  }
}
