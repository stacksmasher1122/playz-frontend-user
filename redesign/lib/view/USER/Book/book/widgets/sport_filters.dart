import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportFilters extends StatefulWidget {
  const SportFilters({super.key});

  @override
  State<SportFilters> createState() => _SportFiltersState();
}

class _SportFiltersState extends State<SportFilters> {
  int _selectedIndex = 0;
  final _bookingController = Get.find<BookingController>();

  final List<String> sports = [
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
    return SizedBox(
      height: ResponsiveHelper.h(40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        itemCount: sports.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (_, i) {
          final bool isSelected = i == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
            onTap: () {
              setState(() {
                _selectedIndex = i;
              });

              // Trigger reactive filter in the controller
              _bookingController.filterTurfsBySport(sports[i]);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent // green background
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              ),
              child: Text(
                sports[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors
                            .black // 🔥 black text on green
                      : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
