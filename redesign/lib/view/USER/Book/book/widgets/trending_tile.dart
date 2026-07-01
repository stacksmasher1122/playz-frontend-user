import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import '../book_screen.dart';
import 'trending_image_shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrendingTile extends StatelessWidget {
  final TrendingData data;
  TrendingTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      width: ResponsiveHelper.w(150),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ IMAGE WITH CACHE + SHIMMER
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveHelper.w(16)),
              ),
              child: CachedNetworkImage(
                imageUrl: data.image,
                cacheKey: data.image,
                height: ResponsiveHelper.h(100),
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => TrendingImageShimmer(),
                errorWidget: (_, __, ___) => Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 28,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '⭐ ${data.rating} • ${data.distance}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
