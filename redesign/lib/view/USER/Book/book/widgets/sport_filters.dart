import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportFilters extends StatefulWidget {
  const SportFilters({super.key});

  @override
  State<SportFilters> createState() => _SportFiltersState();
}

class _SportFiltersState extends State<SportFilters> {
  int _selectedIndex = 0;
  final _bookingController = Get.find<BookingController>();

  final List<String> sports = const [
    'All Sports',
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final filterHeight = context.heightPct(5).clamp(38.0, 44.0);

    return SizedBox(
      height: filterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
        itemCount: sports.length,
        separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
        itemBuilder: (_, i) {
          final bool isSelected = i == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
            onTap: () {
              setState(() {
                _selectedIndex = i;
              });

              // Trigger reactive filter in the controller
              _bookingController.filterTurfsBySport(sports[i]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              ),
              child: Text(
                sports[i],
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
  }
}
