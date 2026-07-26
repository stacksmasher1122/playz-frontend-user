import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'turf_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AvailableTurfsList extends StatelessWidget {
  AvailableTurfsList({super.key});

  final _controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      child: Obx(() {
        // Loading state
        if (_controller.isLoadingTurfs.value) {
          return Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: _TurfCardShimmer(),
              ),
            ),
          );
        }

        // Empty state
        if (_controller.filteredTurfs.isEmpty) {
          final query = _controller.searchQuery.value.trim();
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.sports_outlined,
                    color: AppColors.muted,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    query.isNotEmpty ? 'No turfs matching "$query"' : 'No turfs found',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try changing your search query or filters',
                    style: TextStyle(
                      color: AppColors.muted.withValues(alpha: 0.6),
                      fontSize: ResponsiveHelper.sp(13),
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
                  padding: EdgeInsets.only(bottom: 18),
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
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade800,
      child: Container(
        height: width * 0.48 + 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        ),
      ),
    );
  }
}
