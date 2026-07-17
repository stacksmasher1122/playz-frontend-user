import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CreateTournamentSkeleton extends StatelessWidget {
  const CreateTournamentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: AppColors.card,
        highlightColor: AppColors.surface,
        child: Column(children: [
          // AppBar skeleton
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(AppDimensions.md)),
            child: Row(children: [
              _SkeletonCircle(size: ResponsiveHelper.w(24)),
              const Spacer(),
              _SkeletonText(width: w * 0.45),
              const Spacer(),
              _SkeletonCircle(size: ResponsiveHelper.w(24)),
            ]),
          ),
          SizedBox(height: ResponsiveHelper.h(AppDimensions.sm)),
          // Step progress bars
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(AppDimensions.md)),
            child: Row(
              children: List.generate(5, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(3)),
                  child: _SkeletonBox(width: double.infinity, height: ResponsiveHelper.h(3), radius: 2),
                ),
              )),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
          // Scrollable content
          Expanded(child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(ResponsiveHelper.w(AppDimensions.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _SkeletonText(width: w * 0.3),                              // Select Sport
              SizedBox(height: ResponsiveHelper.h(AppDimensions.sm)),
              SizedBox(height: ResponsiveHelper.w(w * 0.27), child: Row(children: List.generate(4, (_) =>
                Padding(padding: EdgeInsets.only(right: ResponsiveHelper.w(AppDimensions.sm)),
                  child: _SkeletonBox(width: w * 0.22, height: w * 0.27, radius: 12))))),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.lg)),
              _SkeletonText(width: w * 0.3),                              // Basic Details
              SizedBox(height: ResponsiveHelper.h(AppDimensions.sm)),
              _SkeletonBox(width: double.infinity, height: h * 0.13, radius: 12), // Cover image
              SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
              _SkeletonText(width: w * 0.4),                              // Tournament Name label
              SizedBox(height: ResponsiveHelper.h(AppDimensions.xs)),
              _SkeletonBox(width: double.infinity, height: ResponsiveHelper.h(52), radius: 12),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
              Row(children: [_SkeletonText(width: w*0.25), SizedBox(width: ResponsiveHelper.w(AppDimensions.lg)), _SkeletonText(width: w*0.25)]),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.xs)),
              Row(children: [
                _SkeletonBox(width: w*0.44, height: ResponsiveHelper.h(52), radius:12),
                SizedBox(width: ResponsiveHelper.w(AppDimensions.sm)),
                _SkeletonBox(width: w*0.44, height: ResponsiveHelper.h(52), radius:12),
              ]),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
              _SkeletonText(width: w * 0.45),                             // Timings label
              SizedBox(height: ResponsiveHelper.h(AppDimensions.xs)),
              _SkeletonBox(width: double.infinity, height: ResponsiveHelper.h(52), radius: 12),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
              _SkeletonBox(width: double.infinity, height: ResponsiveHelper.h(70), radius: 12), // Access toggle card
              SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
              _SkeletonText(width: w * 0.25),                             // Description label
              SizedBox(height: ResponsiveHelper.h(AppDimensions.xs)),
              _SkeletonBox(width: double.infinity, height: h * 0.12, radius: 12),
              SizedBox(height: ResponsiveHelper.h(AppDimensions.xl)),
            ]),
          )),
          // Bottom action bar skeleton
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(AppDimensions.md)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(width: w*0.26, height: ResponsiveHelper.h(48), radius:12),
                _SkeletonBox(width: w*0.28, height: ResponsiveHelper.h(20), radius:4),
                _SkeletonBox(width: w*0.30, height: ResponsiveHelper.h(48), radius:24),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(AppDimensions.md)),
        ]),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width, height; 
  final double radius;
  const _SkeletonBox({required this.width, required this.height, this.radius=8});
  @override 
  Widget build(BuildContext context) => Container(
    width: width, height: height,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(ResponsiveHelper.w(radius))));
}

class _SkeletonCircle extends StatelessWidget {
  final double size; 
  const _SkeletonCircle({required this.size});
  @override 
  Widget build(BuildContext context) => Container(width: size, height: size,
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
}

class _SkeletonText extends StatelessWidget {
  final double width; 
  final double height;
  const _SkeletonText({required this.width, this.height=14});
  @override 
  Widget build(BuildContext context) => _SkeletonBox(width: width, height: ResponsiveHelper.h(height), radius: 4);
}
