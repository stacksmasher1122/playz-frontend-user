import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmBackgroundEffectWidget extends StatelessWidget {
  SmBackgroundEffectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(child: Container(color: AppColors.background)),
              Positioned(
                top: -height * 0.1,
                right: -width * 0.1,
                width: width * 0.5,
                height: height * 0.5,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -height * 0.05,
                left: -width * 0.05,
                width: width * 0.4,
                height: height * 0.4,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
