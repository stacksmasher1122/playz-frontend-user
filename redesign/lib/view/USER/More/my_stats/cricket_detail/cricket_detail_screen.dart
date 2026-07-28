import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';
import 'package:redesign/model/User_Models/More_Models/cricket_stats_detail_model.dart';

import '../my_stats/widgets/my_stats_app_bar.dart';
import 'widgets/cricket_hero_header.dart';
import 'widgets/cricket_batting_card.dart';
import 'widgets/cricket_milestones_format_card.dart';
import 'widgets/cricket_bowling_card.dart';
import 'widgets/cricket_fielding_rating_card.dart';
import 'widgets/cricket_trends_chart.dart';
import 'widgets/cricket_recent_matches_card.dart';

class CricketDetailScreen extends StatelessWidget {
  final SportStatModel? stat;

  const CricketDetailScreen({super.key, this.stat});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final data = CricketStatsDetailModel.getSampleData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MyStatsAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: ResponsiveHelper.h(10)),
            CricketHeroHeader(data: data),
            SizedBox(height: ResponsiveHelper.h(20)),
            CricketBattingCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            CricketMilestonesFormatCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            CricketBowlingCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            CricketFieldingRatingCard(data: data),
            SizedBox(height: ResponsiveHelper.h(24)),
            const CricketTrendsChart(),
            SizedBox(height: ResponsiveHelper.h(24)),
            CricketRecentMatchesCard(matches: data.recentMatches),
            SizedBox(height: ResponsiveHelper.h(40)),
          ],
        ),
      ),
    );
  }
}
