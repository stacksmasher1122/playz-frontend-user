import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingImageShimmer extends StatelessWidget {
  TrendingImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: ResponsiveHelper.h(100),
        width: double.infinity,
        color: Colors.grey.shade800,
      ),
    );
  }
}
