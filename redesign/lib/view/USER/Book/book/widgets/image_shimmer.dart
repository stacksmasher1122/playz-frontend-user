import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageShimmer extends StatelessWidget {
  final double height;
  const ImageShimmer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade800,
      ),
    );
  }
}
