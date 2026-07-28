import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ImageShimmer extends StatelessWidget {
  final double height;
  const ImageShimmer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
      highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.card,
      ),
    );
  }
}
