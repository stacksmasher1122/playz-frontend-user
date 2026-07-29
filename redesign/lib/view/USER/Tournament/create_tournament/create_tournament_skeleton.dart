import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
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
        highlightColor: AppColors.surfaceElevated,
        child: Column(
          children: [
            // AppBar skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: Row(
                children: [
                  _SkeletonCircle(size: context.widthPct(6)),
                  const Spacer(),
                  _SkeletonText(width: w * 0.45),
                  const Spacer(),
                  _SkeletonCircle(size: context.widthPct(6)),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(1)),
            // Step progress bars
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: Row(
                children: List.generate(
                  5,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.8)),
                      child: _SkeletonBox(
                        width: double.infinity,
                        height: context.heightPct(0.4),
                        radius: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(2)),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(context.widthPct(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonText(width: w * 0.3),
                    SizedBox(height: context.heightPct(1.2)),
                    SizedBox(
                      height: context.heightPct(12),
                      child: Row(
                        children: List.generate(
                          4,
                          (_) => Padding(
                            padding: EdgeInsets.only(right: context.widthPct(3)),
                            child: _SkeletonBox(
                              width: w * 0.22,
                              height: context.heightPct(12),
                              radius: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.heightPct(2.5)),
                    _SkeletonText(width: w * 0.3),
                    SizedBox(height: context.heightPct(1.2)),
                    _SkeletonBox(width: double.infinity, height: h * 0.13, radius: 12),
                    SizedBox(height: context.heightPct(2)),
                    _SkeletonText(width: w * 0.4),
                    SizedBox(height: context.heightPct(0.8)),
                    _SkeletonBox(
                      width: double.infinity,
                      height: context.heightPct(6),
                      radius: 12,
                    ),
                    SizedBox(height: context.heightPct(2)),
                    Row(
                      children: [
                        _SkeletonText(width: w * 0.25),
                        SizedBox(width: context.widthPct(4)),
                        _SkeletonText(width: w * 0.25),
                      ],
                    ),
                    SizedBox(height: context.heightPct(0.8)),
                    Row(
                      children: [
                        _SkeletonBox(width: w * 0.44, height: context.heightPct(6), radius: 12),
                        SizedBox(width: context.widthPct(4)),
                        _SkeletonBox(width: w * 0.44, height: context.heightPct(6), radius: 12),
                      ],
                    ),
                    SizedBox(height: context.heightPct(2)),
                    _SkeletonText(width: w * 0.45),
                    SizedBox(height: context.heightPct(0.8)),
                    _SkeletonBox(
                      width: double.infinity,
                      height: context.heightPct(6),
                      radius: 12,
                    ),
                    SizedBox(height: context.heightPct(2)),
                    _SkeletonBox(width: double.infinity, height: context.heightPct(8.5), radius: 12),
                    SizedBox(height: context.heightPct(2)),
                    _SkeletonText(width: w * 0.25),
                    SizedBox(height: context.heightPct(0.8)),
                    _SkeletonBox(width: double.infinity, height: h * 0.12, radius: 12),
                    SizedBox(height: context.heightPct(3)),
                  ],
                ),
              ),
            ),
            // Bottom action bar skeleton
            Padding(
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(width: w * 0.26, height: context.heightPct(5.5), radius: 12),
                  _SkeletonBox(width: w * 0.28, height: context.heightPct(2.5), radius: 4),
                  _SkeletonBox(width: w * 0.30, height: context.heightPct(5.5), radius: 24),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(2)),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const _SkeletonBox({required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        ),
      );
}

class _SkeletonCircle extends StatelessWidget {
  final double size;
  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          shape: BoxShape.circle,
        ),
      );
}

class _SkeletonText extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonText({required this.width}) : height = 14;

  @override
  Widget build(BuildContext context) => _SkeletonBox(
        width: width,
        height: context.responsiveFont(height),
        radius: 4,
      );
}
