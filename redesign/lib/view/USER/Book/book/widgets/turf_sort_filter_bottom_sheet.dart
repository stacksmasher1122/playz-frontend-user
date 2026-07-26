import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TurfSortFilterBottomSheet extends StatelessWidget {
  const TurfSortFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bookingCtrl = Get.find<BookingController>();

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HANDLE & HEADER
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Sort & Filter Turfs',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),

            /// SORT BY OPTIONS
            Text(
              'Sort By',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Obx(() {
              final selected = bookingCtrl.sortOption.value;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SortChip(
                    label: 'Nearest',
                    isSelected: selected == TurfSortOption.nearest,
                    onTap: () => bookingCtrl.sortOption.value = TurfSortOption.nearest,
                  ),
                  _SortChip(
                    label: 'Top Rated',
                    isSelected: selected == TurfSortOption.topRated,
                    onTap: () => bookingCtrl.sortOption.value = TurfSortOption.topRated,
                  ),
                  _SortChip(
                    label: 'Price: Lowest First',
                    isSelected: selected == TurfSortOption.priceAsc,
                    onTap: () => bookingCtrl.sortOption.value = TurfSortOption.priceAsc,
                  ),
                  _SortChip(
                    label: 'Price: Highest First',
                    isSelected: selected == TurfSortOption.priceDesc,
                    onTap: () => bookingCtrl.sortOption.value = TurfSortOption.priceDesc,
                  ),
                  _SortChip(
                    label: 'Name: A to Z',
                    isSelected: selected == TurfSortOption.nameAsc,
                    onTap: () => bookingCtrl.sortOption.value = TurfSortOption.nameAsc,
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),

            /// DISTANCE RADIUS SLIDER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Radius',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => Text(
                      '${bookingCtrl.distanceRadiusKm.value.toInt()} km',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 4),

            Obx(() {
              return SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.accent,
                  inactiveTrackColor: Colors.grey.shade800,
                  thumbColor: AppColors.accent,
                  overlayColor: AppColors.accent.withValues(alpha: 0.2),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: AppColors.accent,
                  valueIndicatorTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                child: Slider(
                  value: bookingCtrl.distanceRadiusKm.value,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  label: '${bookingCtrl.distanceRadiusKm.value.toInt()} km',
                  onChanged: (val) {
                    bookingCtrl.distanceRadiusKm.value = val;
                  },
                ),
              );
            }),
            Text(
              'Showing turfs within ${bookingCtrl.distanceRadiusKm.value.toInt()} km around your location',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: ResponsiveHelper.sp(11.5),
              ),
            ),

            const SizedBox(height: 24),

            /// APPLY BUTTON
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(48),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.sp(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
