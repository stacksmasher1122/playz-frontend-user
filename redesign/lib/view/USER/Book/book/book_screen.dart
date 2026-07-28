import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/available_turfs_list.dart';
import 'widgets/end_of_results.dart';
import 'widgets/filter_row.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/sport_filters.dart';
import 'widgets/top_bar.dart';
import 'widgets/trending_list.dart';

/* ============================================================
   BOOK TURF SCREEN
   ============================================================ */
class BookTurfScreen extends StatefulWidget {
  const BookTurfScreen({super.key});

  @override
  State<BookTurfScreen> createState() => _BookTurfScreenState();
}

class _BookTurfScreenState extends State<BookTurfScreen> {
  final _controller = Get.find<UserProfileController>();
  final _bookingController = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          onRefresh: () => _bookingController.fetchAllTurfs(),
          child: ListView(
            padding: EdgeInsets.only(bottom: context.heightPct(10)),
            children: [
              TopBar(),
              SizedBox(height: context.heightPct(1.8)),
              const SearchBarWidget(),
              SizedBox(height: context.heightPct(2)),
              const SportFilters(),
              SizedBox(height: context.heightPct(3)),
              const SectionHeader(title: 'Trending Near You'),
              SizedBox(height: context.heightPct(1.8)),
              TrendingList(),
              SizedBox(height: context.heightPct(2)),
              const FilterRow(),
              SizedBox(height: context.heightPct(3)),
              const SectionHeader(title: 'Available Turfs'),
              SizedBox(height: context.heightPct(1.8)),
              AvailableTurfsList(),
              EndOfResults(),
            ],
          ),
        ),
      ),
    );
  }
}
