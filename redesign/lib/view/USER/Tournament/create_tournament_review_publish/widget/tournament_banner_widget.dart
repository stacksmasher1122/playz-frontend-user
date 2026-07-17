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
    return Container(
      width: double.infinity,
      height: ResponsiveHelper.h(192), // ~48 Tailwind units
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(32)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
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
            bottom: ResponsiveHelper.w(16),
            left: ResponsiveHelper.w(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.displaySm.copyWith(color: AppColors.onPrimary),
                ),
                SizedBox(height: ResponsiveHelper.h(8)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(12),
                        vertical: ResponsiveHelper.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(50)),
                      ),
                      child: Text(
                        type,
                        style: AppTypography.labelCaps.copyWith(color: AppColors.accent),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.w(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(12),
                        vertical: ResponsiveHelper.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(50)),
                      ),
                      child: Text(
                        category,
                        style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimary),
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
