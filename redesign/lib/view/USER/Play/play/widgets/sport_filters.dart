import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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

    final sports = [
      ('All', Icons.sports),
      ('Football', Icons.sports_soccer),
      ('Cricket', Icons.sports_cricket),
      ('Badminton', Icons.sports_tennis),
      ('Basketball', Icons.sports_basketball),
      ('Tennis', Icons.sports_tennis),
      ('Volleyball', Icons.sports_volleyball),
    ];

    return SizedBox(
      height: ResponsiveHelper.h(44),
      child: Obx(() {
        final currentSport = matchCtrl.selectedSport.value;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          scrollDirection: Axis.horizontal,
          itemCount: sports.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
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
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                  border: Border.all(
                    color: isActive ? AppColors.accent : Colors.white12,
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
                      color: isActive ? AppColors.accent : Colors.white70,
                    ),
                    SizedBox(width: 8),
                    Text(
                      sportName,
                      style: GoogleFonts.inter(
                        color: isActive ? AppColors.accent : Colors.white,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                        fontSize: ResponsiveHelper.sp(13),
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
