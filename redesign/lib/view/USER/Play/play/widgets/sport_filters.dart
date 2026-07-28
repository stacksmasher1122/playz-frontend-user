import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';

class SportFilters extends StatelessWidget {
  const SportFilters({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final matchCtrl = Get.isRegistered<MatchController>()
        ? Get.find<MatchController>()
        : Get.put(MatchController());

    final sports = const [
      ('All', Icons.sports),
      ('Football', Icons.sports_soccer),
      ('Cricket', Icons.sports_cricket),
      ('Badminton', Icons.sports_tennis),
      ('Basketball', Icons.sports_basketball),
      ('Tennis', Icons.sports_tennis),
      ('Volleyball', Icons.sports_volleyball),
    ];

    final barHeight = context.heightPct(5).clamp(40.0, 48.0);

    return SizedBox(
      height: barHeight,
      child: Obx(() {
        final currentSport = matchCtrl.selectedSport.value;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          scrollDirection: Axis.horizontal,
          itemCount: sports.length,
          separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
          itemBuilder: (_, i) {
            final sportName = sports[i].$1;
            final icon = sports[i].$2;
            final isActive = currentSport.toLowerCase() == sportName.toLowerCase();

            return GestureDetector(
              onTap: () {
                matchCtrl.selectedSport.value = sportName;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
                  border: Border.all(
                    color: isActive ? AppColors.accent : AppColors.borderDark,
                    width: isActive ? 1.5 : 1.0,
                  ),
                  color: isActive
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.surface,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isActive ? AppColors.accent : AppColors.textSecondary,
                    ),
                    SizedBox(width: context.widthPct(2)),
                    Text(
                      sportName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        color: isActive ? AppColors.accent : AppColors.textPrimary,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
