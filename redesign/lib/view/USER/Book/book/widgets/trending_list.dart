import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'trending_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingList extends StatelessWidget {
  TrendingList({super.key});

  final _controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final cardHeight = context.heightPct(20).clamp(160.0, 190.0);
    final tileWidth = context.widthPct(38).clamp(140.0, 170.0);

    return SizedBox(
      height: cardHeight,
      child: Obx(() {
        // Loading state
        if (_controller.isLoadingTurfs.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: context.widthPct(3)),
            itemBuilder: (_, i) => Shimmer.fromColors(
              baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
              highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
              child: Container(
                width: tileWidth,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
              ),
            ),
          );
        }

        // Take first 5 verified turfs as "trending"
        final trending = _controller.allTurfs.take(5).toList();

        if (trending.isEmpty) {
          return Center(
            child: Text(
              'No trending turfs',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
            ),
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          itemCount: trending.length,
          separatorBuilder: (_, __) => SizedBox(width: context.widthPct(3.5)),
          itemBuilder: (_, i) => TrendingTile(turf: trending[i]),
        );
      }),
    );
  }
}
