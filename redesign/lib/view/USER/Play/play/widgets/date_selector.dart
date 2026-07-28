import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final matchCtrl = Get.isRegistered<MatchController>()
        ? Get.find<MatchController>()
        : Get.put(MatchController());

    final dates = List.generate(
      14,
      (i) => DateTime.now().add(Duration(days: i)),
    );

    final cardHeight = context.heightPct(9).clamp(70.0, 84.0);
    final cardWidth = context.widthPct(15).clamp(52.0, 66.0);

    return SizedBox(
      height: cardHeight,
      child: Obx(() {
        final selectedDate = matchCtrl.selectedDate.value ?? dates.first;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
          itemBuilder: (_, index) {
            final d = dates[index];
            final isSelected = selectedDate.year == d.year &&
                selectedDate.month == d.month &&
                selectedDate.day == d.day;

            return GestureDetector(
              onTap: () {
                matchCtrl.selectedDate.value = d;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: cardWidth,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.borderDark,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// MONTH
                    Text(
                      DateFormat('MMM').format(d),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelCaps10.copyWith(
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.background : AppColors.muted,
                      ),
                    ),

                    SizedBox(height: context.heightPct(0.3)),

                    /// DATE
                    Text(
                      '${d.day}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: context.responsiveFont(16),
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: context.heightPct(0.3)),

                    /// DAY
                    Text(
                      DateFormat('EEE').format(d),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyXs.copyWith(
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.w400,
                        color: isSelected ? AppColors.background : AppColors.muted,
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
