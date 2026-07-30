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
          final isFavoritesOnly = _controller.isFavoritesOnly.value;
          final selectedSport = _controller.selectedSport.value;

          String title = 'No turfs found';
          String subtitle = 'Try changing your search query or filters';

          if (isFavoritesOnly) {
            title = 'No favorite turfs added yet';
            subtitle = 'Tap the ❤ icon on any turf to add it to your favorites';
          } else if (query.isNotEmpty) {
            title = 'No turfs matching "$query"';
            subtitle = 'Try changing your search query or filters';
          } else if (selectedSport != null &&
              selectedSport.isNotEmpty &&
              selectedSport != 'All Sports') {
            title = 'No turfs available for $selectedSport';
            subtitle = 'Try selecting another sport or clearing your filter';
          }

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(5)),
              child: Column(
                children: [
                  Icon(
                    isFavoritesOnly ? Icons.favorite_border : Icons.sports_outlined,
                    color: isFavoritesOnly ? AppColors.accent : AppColors.muted,
                    size: 48,
                  ),
                  SizedBox(height: context.heightPct(1.5)),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Text(
                    subtitle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                  if ((selectedSport != null &&
                          selectedSport.isNotEmpty &&
                          selectedSport != 'All Sports') ||
                      query.isNotEmpty ||
                      isFavoritesOnly) ...[
                    SizedBox(height: context.heightPct(2.2)),
                    ElevatedButton(
                      onPressed: () {
                        _controller.isFavoritesOnly.value = false;
                        _controller.searchQuery.value = '';
                        _controller.filterTurfsBySport('All Sports');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(6),
                          vertical: context.heightPct(1.4),
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Explore Other Sports',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.background,
                            fontSize: context.responsiveFont(13),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
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
