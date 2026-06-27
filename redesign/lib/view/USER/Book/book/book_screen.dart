import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: const [
            TopBar(),
            SizedBox(height: 14),
            SearchBarWidget(),
            SizedBox(height: 16),
            SportFilters(),
            SizedBox(height: 28),
            SectionHeader(title: 'Trending Near You'),
            SizedBox(height: 14),
            TrendingList(),
            SizedBox(height: 16),
            FilterRow(),
            SizedBox(height: 28),
            SectionHeader(title: 'Available Turfs'),
            SizedBox(height: 14),
            AvailableTurfsList(),
            SizedBox(height: 0),
            EndOfResults(),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   DATA MODELS
   ============================================================ */
class TurfData {
  final String name;
  final String location;
  final int price;
  final List<String> images;

  TurfData({
    required this.name,
    required this.location,
    required this.price,
    required this.images,
  });
}

class TrendingData {
  final String name;
  final String rating;
  final String distance;
  final String image;

  TrendingData(this.name, this.rating, this.distance, this.image);
}
