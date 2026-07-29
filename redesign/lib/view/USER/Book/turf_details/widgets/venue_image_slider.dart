import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueImageSlider extends StatelessWidget {
  final List<String> images;
  final List<String> sports;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const VenueImageSlider({
    super.key,
    required this.images,
    required this.sports,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sliderHeight = context.heightPct(35).clamp(240.0, 320.0);

    // Build badge text from sports list
    final badgeText = sports.isNotEmpty
        ? sports.take(2).join(' & ').toUpperCase()
        : '';

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
                    return CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.surfaceElevated,
                        highlightColor: AppColors.borderDark,
                        child: Container(color: AppColors.surface),
                      ),
                    );
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

        /// TOP ICONS
        Positioned(
          top: context.heightPct(4),
          left: context.widthPct(4),
          child: _circleIcon(context, Icons.arrow_back, onTap: () => Navigator.pop(context)),
        ),
        Positioned(
          top: context.heightPct(4),
          right: context.widthPct(4),
          child: _circleIcon(context, Icons.favorite_border),
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

        if (badgeText.isNotEmpty)
          Positioned(
            bottom: context.heightPct(1.5),
            left: context.widthPct(3),
            child: _greenBadge(context, badgeText),
          ),
      ],
    );
  }

  Widget _greenBadge(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
      ),
      child: Text(
        text,
        style: AppTypography.labelCaps10.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveFont(11),
        ),
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    final avatarRadius = context.minDimensionPct(5).clamp(18.0, 24.0);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: AppColors.background.withValues(alpha: 0.6),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
