import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FilterRow extends StatefulWidget {
  const FilterRow({super.key});

  @override
  State<FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  int _selectedIndex = 0;

  final List<String> filters = [
    'Filters',
    'Nearest',
    'Top Rated',
    'Low Price',
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bookingController = Get.find<BookingController>();
    final rowHeight = context.heightPct(5).clamp(38.0, 44.0);

    return SizedBox(
      height: rowHeight,
      child: Obx(() {
        final currentOption = bookingController.sortOption.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          itemCount: filters.length,
          separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2.5)),
          itemBuilder: (context, index) {
            final item = filters[index];
            final String label = item['label'];
            final TurfSortOption? option = item['option'];

            final bool isSelected = option != null && currentOption == option;

            return InkWell(
              borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              onTap: () {
                if (index == 0) {
                  // Open Filter Bottom Sheet
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
                  horizontal: context.widthPct(3.5),
                  vertical: context.heightPct(1),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.background : AppColors.textPrimary,
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
