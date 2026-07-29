import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TournamentBannerWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String type;
  final String category;

  const TournamentBannerWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      width: double.infinity,
      height: context.heightPct(22).clamp(160.0, 220.0),
      margin: EdgeInsets.only(bottom: context.heightPct(3)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.8],
              ),
            ),
          ),
          
          // Content
          Positioned(
            bottom: context.heightPct(2),
            left: context.widthPct(4),
            right: context.widthPct(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.displaySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(22),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.8)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3),
                        vertical: context.heightPct(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                      ),
                      child: Text(
                        type,
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                    ),
                    SizedBox(width: context.widthPct(2)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3),
                        vertical: context.heightPct(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                      ),
                      child: Text(
                        category,
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
