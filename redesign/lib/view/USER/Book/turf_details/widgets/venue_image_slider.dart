import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueImageSlider extends StatelessWidget {
  final String heroTag;
  final String turfId;
  final List<String> images;
  final List<String> sports;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const VenueImageSlider({
    super.key,
    this.heroTag = '',
    required this.turfId,
    required this.images,
    required this.sports,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase().trim()) {
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
      case 'badminton':
      case 'pickleball':
      case 'table tennis':
      case 'squash':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'golf':
        return Icons.sports_golf;
      case 'baseball':
        return Icons.sports_baseball;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sliderHeight = context.heightPct(35).clamp(240.0, 320.0);
    final bookingCtrl = Get.find<BookingController>();

    return Stack(
      children: [
        SizedBox(
          height: sliderHeight,
          child: images.isNotEmpty
              ? PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (_, index) {
                    final imgWidget = CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.surfaceElevated,
                        highlightColor: AppColors.borderDark,
                        child: Container(color: AppColors.surface),
                      ),
                    );

                    final bool isHeroTarget =
                        (index == currentPage || (currentPage >= images.length && index == 0)) &&
                            heroTag.isNotEmpty;

                    if (isHeroTarget) {
                      return Hero(
                        tag: heroTag,
                        transitionOnUserGestures: true,
                        child: Material(
                          color: Colors.transparent,
                          child: imgWidget,
                        ),
                      );
                    }
                    return imgWidget;
                  },
                )
              : Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.muted,
                      size: 48,
                    ),
                  ),
                ),
        ),

        /// TOP LEFT: BACK BUTTON
        Positioned(
          top: context.heightPct(4),
          left: context.widthPct(4),
          child: _circleIcon(
            context,
            Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
        ),

        /// TOP RIGHT: SYNCED FAVORITE BUTTON
        Positioned(
          top: context.heightPct(4),
          right: context.widthPct(4),
          child: Obx(() {
            final isFav = bookingCtrl.isTurfFavorite(turfId);
            return _circleIcon(
              context,
              isFav ? Icons.favorite : Icons.favorite_border,
              iconColor: isFav ? AppColors.accent : AppColors.textPrimary,
              onTap: () => bookingCtrl.toggleFavoriteTurf(turfId),
            );
          }),
        ),

        /// PAGE INDICATORS
        if (images.length > 1)
          Positioned(
            bottom: context.heightPct(3),
            right: context.widthPct(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: context.widthPct(1)),
                  width: currentPage == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? AppColors.accent
                        : AppColors.textPrimary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

        /// BOTTOM LEFT: SPORTS LOGOS (MAX 2 LOGOS THEN +N)
        if (sports.isNotEmpty)
          Positioned(
            bottom: context.heightPct(1.5),
            left: context.widthPct(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...sports.take(2).map((sport) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 1.5),
                    ),
                    child: Icon(
                      _getSportIcon(sport),
                      size: 14,
                      color: AppColors.accent,
                    ),
                  );
                }),
                if (sports.length > 2)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${sports.length - 2}',
                      style: AppTypography.labelCaps10.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _circleIcon(
    BuildContext context,
    IconData icon, {
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final avatarRadius = context.minDimensionPct(5).clamp(18.0, 24.0);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: AppColors.background.withValues(alpha: 0.6),
        child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 20),
      ),
    );
  }
}
