import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueReviewsSection extends StatelessWidget {
  const VenueReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'View All (128)',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.2)),
          _reviewCard(
            context,
            'Michael S.',
            'Great facilities and well maintained equipment.',
          ),
          SizedBox(height: context.heightPct(1.2)),
          _reviewCard(context, 'Priya K.', 'Spacious and clean. Friendly trainers.'),
        ],
      ),
    );
  }

  Widget _reviewCard(BuildContext context, String name, String comment) {
    final avatarRadius = context.minDimensionPct(5).clamp(18.0, 24.0);

    return Container(
      padding: EdgeInsets.all(context.widthPct(3)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150'),
          ),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star, size: 14, color: Colors.amber),
                  ),
                ),
                Text(
                  comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
