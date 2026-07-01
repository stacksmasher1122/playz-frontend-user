import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SuccessRippleAnimation extends StatelessWidget {
  final AnimationController controller;

  SuccessRippleAnimation({
    super.key,
    required this.controller,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      height: ResponsiveHelper.h(120),
      width: ResponsiveHelper.w(120),
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
            width: ResponsiveHelper.w(64),
            height: ResponsiveHelper.h(64),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kGreen,
            ),
            child: Icon(Icons.check, size: 36, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
