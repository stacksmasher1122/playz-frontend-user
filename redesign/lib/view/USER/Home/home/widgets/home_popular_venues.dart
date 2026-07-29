import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   POPULAR VENUES
   ============================================================ */
class HomePopularVenues extends StatelessWidget {
  const HomePopularVenues({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
      child: Column(
        children: [
          const HomeSectionHeader('Popular Venues'),
          SizedBox(height: context.heightPct(1.5)),
          const HomeVenueTile(
            title: 'Urban Kick Turf',
            location: 'Indiranagar • 2.5km',
            price: '₹1200/hr',
            rating: '4.8',
            status: 'Open till 11 PM',
          ),
          SizedBox(height: context.heightPct(1.2)),
          const HomeVenueTile(
            title: 'Skyline Arena',
            location: 'Koramangala • 4.1km',
            price: '₹900/hr',
            rating: '4.6',
            status: 'Filling Fast',
          ),
        ],
      ),
    );
  }
}

class HomeVenueTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String status;

  const HomeVenueTile({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final imageSize = context.minDimensionPct(18).clamp(60.0, 80.0);

    return Container(
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Row(
        children: [
          /// CACHED IMAGE WITH SHIMMER
          ClipRRect(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              cacheKey:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              placeholder: (_, __) => HomeShimmer(
                width: imageSize,
                height: imageSize,
                borderRadius: 12,
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: AppColors.muted),
            ),
          ),

          SizedBox(width: context.widthPct(3.5)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.heightPct(0.4)),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
                SizedBox(height: context.heightPct(0.6)),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.widthPct(2)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(0.8)),
              Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyXs.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: context.responsiveFont(11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
