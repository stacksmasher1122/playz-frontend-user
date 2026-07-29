import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GoalsMissionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int zCoinsBalance;

  const GoalsMissionsAppBar({
    super.key,
    required this.zCoinsBalance,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              child: Container(
                width: context.minDimensionPct(10).clamp(36.0, 44.0),
                height: context.minDimensionPct(10).clamp(36.0, 44.0),
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),

            // Title
            Expanded(
              child: Text(
                'Goals & Missions',
                textAlign: TextAlign.center,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Top Right Z Coins Pill
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3),
                vertical: context.heightPct(0.8),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: AppColors.background,
                      size: 13,
                    ),
                  ),
                  SizedBox(width: context.widthPct(1.5)),
                  Text(
                    '$zCoinsBalance',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.w900,
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
