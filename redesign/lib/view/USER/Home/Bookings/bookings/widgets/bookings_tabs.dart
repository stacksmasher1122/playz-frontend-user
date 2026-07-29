import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsTabs extends StatelessWidget {
  final TabController controller;
  const BookingsTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.only(left: context.widthPct(4)),
      controller: controller,
      indicatorColor: AppColors.accent,
      labelColor: AppColors.accent,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: AppTypography.headlineSm.copyWith(
        fontSize: context.responsiveFont(14),
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: AppTypography.bodySm.copyWith(
        fontSize: context.responsiveFont(14),
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        Tab(text: 'Upcoming'),
        Tab(text: 'Past'),
        Tab(text: 'Cancelled'),
      ],
    );
  }
}
