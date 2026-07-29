import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BuildSquadCTA extends StatelessWidget {
  const BuildSquadCTA({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.2),
        context.widthPct(4),
        context.heightPct(1.2),
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build a New Squad',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.3)),
                  Text(
                    'Book turfs faster with your team.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.background.withValues(alpha: 0.85),
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.widthPct(2)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Start Now',
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
