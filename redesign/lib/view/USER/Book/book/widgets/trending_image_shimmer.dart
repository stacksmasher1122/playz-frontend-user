import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TrendingImageShimmer extends StatelessWidget {
  const TrendingImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey.shade800,
      ),
    );
  }
}
