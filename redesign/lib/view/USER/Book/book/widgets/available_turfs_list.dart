import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'turf_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AvailableTurfsList extends StatelessWidget {
  AvailableTurfsList({super.key});

  final _controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Obx(() {
        // Loading state
        if (_controller.isLoadingTurfs.value) {
          return Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: context.heightPct(2)),
                child: const _TurfCardShimmer(),
              ),
            ),
          );
        }

        // Empty state
        if (_controller.filteredTurfs.isEmpty) {
          final query = _controller.searchQuery.value.trim();
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(5)),
              child: Column(
                children: [
                  const Icon(
                    Icons.sports_outlined,
                    color: AppColors.muted,
                    size: 48,
                  ),
                  SizedBox(height: context.heightPct(1.5)),
                  Text(
                    query.isNotEmpty ? 'No turfs matching "$query"' : 'No turfs found',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Text(
                    'Try changing your search query or filters',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted.withValues(alpha: 0.6),
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Data loaded
        return Column(
          children: _controller.filteredTurfs
              .map(
                (turf) => Padding(
                  padding: EdgeInsets.only(bottom: context.heightPct(2)),
                  child: TurfCard(turf: turf),
                ),
              )
              .toList(),
        );
      }),
    );
  }
}

/// Shimmer placeholder for a turf card while loading
class _TurfCardShimmer extends StatelessWidget {
  const _TurfCardShimmer();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final cardHeight = context.widthPct(48) + context.heightPct(14);

    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
      highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        ),
      ),
    );
  }
}
