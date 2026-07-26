import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'turf_sort_filter_bottom_sheet.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  final List<Map<String, dynamic>> filters = const [
    {'label': 'Filters', 'option': null},
    {'label': 'Nearest', 'option': TurfSortOption.nearest},
    {'label': 'Top Rated', 'option': TurfSortOption.topRated},
    {'label': 'Low Price', 'option': TurfSortOption.priceAsc},
    {'label': 'High Price', 'option': TurfSortOption.priceDesc},
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bookingController = Get.find<BookingController>();

    return SizedBox(
      height: ResponsiveHelper.h(40),
      child: Obx(() {
        final currentOption = bookingController.sortOption.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = filters[index];
            final String label = item['label'];
            final TurfSortOption? option = item['option'];

            final bool isSelected = option != null && currentOption == option;

            return InkWell(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              onTap: () {
                if (index == 0) {
                  // Open Filter Bottom Sheet just like Play screen
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => const TurfSortFilterBottomSheet(),
                  );
                } else if (option != null) {
                  bookingController.sortOption.value = option;
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(14),
                  vertical: ResponsiveHelper.h(8),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
