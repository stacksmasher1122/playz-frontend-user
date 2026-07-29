import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedVenuesList extends StatelessWidget {
  final List<String> images;

  const RecommendedVenuesList({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final cardWidth = context.widthPct(40).clamp(140.0, 180.0);
    final imageHeight = context.heightPct(15).clamp(100.0, 130.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: Text(
            'You Might Also Like',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1.2)),
        SizedBox(
          height: context.heightPct(24).clamp(180.0, 220.0),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(right: context.widthPct(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      child: images.isNotEmpty && index < images.length
                          ? Image.network(
                              images[index],
                              height: imageHeight,
                              width: cardWidth,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: imageHeight,
                              width: cardWidth,
                              color: AppColors.card,
                              child: const Icon(Icons.sports, color: AppColors.muted),
                            ),
                    ),
                    SizedBox(height: context.heightPct(0.8)),
                    Text(
                      'Gold\'s Gym',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '2.3 km • ₹1200/hr',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
