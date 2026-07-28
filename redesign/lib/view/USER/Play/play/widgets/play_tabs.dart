import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayTabs extends StatelessWidget {
  const PlayTabs({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(5),
        vertical: context.heightPct(1),
      ),
      child: Row(
        children: [
          Text(
            'Game Diary',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.widthPct(5)),
          Text(
            'All Games',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(14),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
