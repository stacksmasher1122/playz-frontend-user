import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../host_match/host_match_screen.dart';
import 'sort_filter_bottom_sheet.dart';

class PlayActionRow extends StatelessWidget {
  const PlayActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(5),
        vertical: context.heightPct(1.2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HostMatchScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3.5),
                vertical: context.heightPct(1),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: AppColors.accent, size: 18),
                  SizedBox(width: context.widthPct(1.5)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Host Game +',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SortFilterBottomSheet(),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3.5),
                vertical: context.heightPct(1),
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert, color: AppColors.textPrimary, size: 16),
                  SizedBox(width: context.widthPct(1.5)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Sort & Filter',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
