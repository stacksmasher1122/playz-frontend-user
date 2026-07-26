import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
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

    return SizedBox(
      height: ResponsiveHelper.h(76),
      child: Obx(() {
        final selectedDate = matchCtrl.selectedDate.value ?? dates.first;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
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
                width: ResponsiveHelper.w(58),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.white12,
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
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : AppColors.muted,
                      ),
                    ),

                    SizedBox(height: 2),

                    /// DATE
                    Text(
                      '${d.day}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),

                    SizedBox(height: 2),

                    /// DAY
                    Text(
                      DateFormat('EEE').format(d),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(11),
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.black : AppColors.muted,
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
