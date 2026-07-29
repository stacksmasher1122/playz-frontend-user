import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'filter_chip.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsSearchAndFilters extends StatelessWidget {
  const BookingsSearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(1),
            context.widthPct(4),
            context.heightPct(1),
          ),
          child: TextField(
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(13),
            ),
            decoration: InputDecoration(
              hintText: 'Search by venue, sport or ID…',
              hintStyle: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
          child: const Row(
            children: [
              BookingFilterChip('Filters', icon: Icons.tune),
              BookingFilterChip('This Week'),
              BookingFilterChip('Football'),
              BookingFilterChip('Cricket'),
              BookingFilterChip('Badminton'),
            ],
          ),
        ),
      ],
    );
  }
}
