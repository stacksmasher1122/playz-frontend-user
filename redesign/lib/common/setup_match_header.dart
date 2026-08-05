import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable setup match upper banner displaying the screen title, subtitle,
/// and a high-resolution 3D sport asset (e.g. 3D Cricket Pitch).
class SetupMatchHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final double imageHeight;
  final EdgeInsetsGeometry? margin;

  const SetupMatchHeader({
    super.key,
    this.title = 'Setup Match',
    this.subtitle = 'Configure your match rules\nand draft your squads.',
    this.imageAsset = 'assets/cricket_pitch_3d.png',
    this.imageHeight = 110.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: ResponsiveHelper.h(24.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(32.0),
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ).responsive(context),
                ),
                SizedBox(height: ResponsiveHelper.h(8.0)),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(14.0),
                    height: 1.4,
                  ).responsive(context),
                ),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.w(12.0)),

          // Right 3D Asset Image
          SizedBox(
            height: ResponsiveHelper.h(imageHeight),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) {
                // Fallback icon if asset is not found
                return Icon(
                  Icons.sports_cricket,
                  size: ResponsiveHelper.w(64.0),
                  color: AppColors.accent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
