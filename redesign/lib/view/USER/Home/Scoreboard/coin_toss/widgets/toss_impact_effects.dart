import 'dart:math';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TossImpactEffects extends StatelessWidget {
  final double haloRadius;
  final double haloOpacity;
  final double shakeValue;
  final bool isShakeAnimating;

  TossImpactEffects({
    super.key,
    required this.haloRadius,
    required this.haloOpacity,
    required this.shakeValue,
    required this.isShakeAnimating,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: Container(
            width: haloRadius,
            height: haloRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFF7E7A1).withValues(alpha: haloOpacity),
                width: ResponsiveHelper.w(2.5),
              ),
            ),
          ),
        ),
        if (isShakeAnimating)
          ...List.generate(6, (index) {
            final angle = (index * 2 * pi) / 6;
            return Transform.translate(
              offset: Offset(
                cos(angle) * 70 * shakeValue,
                sin(angle) * 20 * shakeValue,
              ),
              child: Opacity(
                opacity: 1.0 - shakeValue,
                child: Container(
                  width: ResponsiveHelper.w(4.5),
                  height: ResponsiveHelper.h(4.5),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7E7A1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
