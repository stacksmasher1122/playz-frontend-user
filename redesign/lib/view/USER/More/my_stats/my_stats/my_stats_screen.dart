import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/my_stats_overview_model.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';

import 'widgets/my_stats_app_bar.dart';
import 'widgets/my_stats_sport_card.dart';

import '../cricket_detail/cricket_detail_screen.dart';
import '../football_detail/football_detail_screen.dart';
import '../badminton_detail/badminton_detail_screen.dart';

class MyStatsScreen extends StatelessWidget {
  const MyStatsScreen({super.key});

  void _openDetailScreen(BuildContext context, String sportName) {
    final sampleStats = SportStatModel.getSampleStats();
    if (sportName == 'Cricket') {
      final stat = sampleStats.firstWhere((s) => s.name == 'Cricket');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CricketDetailScreen(stat: stat)),
      );
    } else if (sportName == 'Football') {
      final stat = sampleStats.firstWhere((s) => s.name == 'Football');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FootballDetailScreen(stat: stat)),
      );
    } else if (sportName == 'Badminton') {
      final stat = sampleStats.firstWhere((s) => s.name == 'Badminton');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BadmintonDetailScreen(stat: stat)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final items = MyStatsOverviewItem.getSampleItems();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MyStatsAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: ResponsiveHelper.h(16)),

            // Title: My Stats
            Text(
              'My Stats',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(4)),

            // Subtitle: Lifetime performance across all sports.
            Text(
              'Lifetime performance across all sports.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),

            SizedBox(height: ResponsiveHelper.h(24)),

            // 3 Sports Cards (Cricket, Football, Badminton)
            ...items.map((item) {
              return MyStatsSportCard(
                item: item,
                onTap: () => _openDetailScreen(context, item.sportName),
              );
            }),

            SizedBox(height: ResponsiveHelper.h(40)),
          ],
        ),
      ),
    );
  }
}
