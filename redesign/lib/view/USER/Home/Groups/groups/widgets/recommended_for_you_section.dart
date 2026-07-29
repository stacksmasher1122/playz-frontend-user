import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'recommended_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedForYouSection extends StatelessWidget {
  const RecommendedForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
      margin: EdgeInsets.symmetric(vertical: context.heightPct(0.8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECOMMENDED FOR YOU',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'SEE ALL',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.heightPct(1.5)),
          const RecommendedCard(
            name: 'Pune Runners Club',
            members: '1.2K MEMBERS',
            status: 'ACTIVE NOW',
            imageUrl:
                'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
          ),
          SizedBox(height: context.heightPct(1.2)),
          const RecommendedCard(
            name: 'Badminton Smashers',
            members: '840 MEMBERS',
            status: '12 ACTIVE',
            imageUrl:
                'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea',
          ),
        ],
      ),
    );
  }
}
