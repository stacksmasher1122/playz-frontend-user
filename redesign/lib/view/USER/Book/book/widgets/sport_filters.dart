import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportFilters extends StatelessWidget {
  const SportFilters({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bookingController = Get.isRegistered<BookingController>()
        ? Get.find<BookingController>()
        : Get.put(BookingController());

    final filterHeight = context.heightPct(5).clamp(38.0, 44.0);

    return Obx(() {
      final turfSports = bookingController.allTurfs
          .expand((t) => t.sports)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toSet();

      const defaultSports = [
        'Cricket',
        'Football',
        'Badminton',
        'Basketball',
        'Tennis',
        'Volleyball',
        'Pickleball',
        'Table Tennis',
      ];

      final combinedSportsSet = <String>{
        ...defaultSports,
        ...turfSports,
      };

      final sports = <String>[
        'All Sports',
        ...combinedSportsSet,
      ];

      final currentSelected = bookingController.selectedSport.value;

      return SizedBox(
        height: filterHeight,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          itemCount: sports.length,
          separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
          itemBuilder: (_, i) {
            final sportName = sports[i];
            final bool isSelected = (sportName == 'All Sports' &&
                    (currentSelected == null ||
                        currentSelected.isEmpty ||
                        currentSelected == 'All Sports')) ||
                currentSelected?.toLowerCase() == sportName.toLowerCase();

            return InkWell(
              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              onTap: () {
                bookingController.filterTurfsBySport(sportName);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(context.minDimensionPct(5)),
                ),
                child: Text(
                  sportName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
