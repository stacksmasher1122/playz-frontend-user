import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   SHIMMER PLACEHOLDER (REUSABLE)
   ============================================================ */
class HomeShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;

  const HomeShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
      highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
