import 'package:flutter/material.dart';
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

  HomeShimmer({super.key, this.width, this.height, this.borderRadius = 0, this.child});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900.withValues(alpha: 0.5),
      highlightColor: Colors.grey.shade800.withValues(alpha: 0.4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
