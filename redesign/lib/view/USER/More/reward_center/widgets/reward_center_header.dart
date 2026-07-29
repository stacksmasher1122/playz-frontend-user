import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RewardCenterHeader extends StatelessWidget {
  final int coinsBalance;

  const RewardCenterHeader({super.key, required this.coinsBalance});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      padding: EdgeInsets.all(context.widthPct(5)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.accent.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.stars_rounded,
              size: 140,
              color: AppColors.accent.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(2.5),
                      vertical: context.heightPct(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: AppColors.accent, size: 16),
                        SizedBox(width: context.widthPct(1)),
                        Text(
                          'PLAYZ REWARDS CLUB',
                          style: AppTypography.labelCaps10.copyWith(
                            color: AppColors.accent,
                            fontSize: context.responsiveFont(11),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(context.widthPct(1.5)),
                    decoration: BoxDecoration(
                      color: AppColors.coinsGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: AppColors.coinsGold, size: 18),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(2)),
              Text(
                'YOUR Z-COINS BALANCE',
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(11),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: context.heightPct(0.5)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Icon(Icons.monetization_on_rounded, color: AppColors.coinsGold, size: 36),
                  SizedBox(width: context.widthPct(2)),
                  Text(
                    '$coinsBalance',
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(38),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: context.widthPct(2)),
                  Text(
                    'Coins',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(1.5)),
              Text(
                'Earn more coins by playing matches, hosting games, & inviting friends!',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
