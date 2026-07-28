import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';
import 'package:redesign/model/User_Models/More_Models/football_stats_detail_model.dart';

import '../my_stats/widgets/my_stats_app_bar.dart';
import 'widgets/football_hero_header.dart';
import 'widgets/football_core_stats_card.dart';
import 'widgets/football_metrics_grid_card.dart';
import 'widgets/football_accuracy_bars_card.dart';
import 'widgets/football_trends_chart.dart';
import 'widgets/football_radar_profile_card.dart';
import 'widgets/football_record_discipline_card.dart';
import 'widgets/football_recent_matches_card.dart';

class FootballDetailScreen extends StatelessWidget {
  final SportStatModel? stat;

  const FootballDetailScreen({super.key, this.stat});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final data = FootballStatsDetailModel.getSampleData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MyStatsAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: ResponsiveHelper.h(10)),
            FootballHeroHeader(data: data),
            SizedBox(height: ResponsiveHelper.h(20)),
            FootballCoreStatsCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            FootballMetricsGridCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            FootballAccuracyBarsCard(data: data),
            SizedBox(height: ResponsiveHelper.h(24)),
            const FootballTrendsChart(),
            SizedBox(height: ResponsiveHelper.h(24)),
            const FootballRadarProfileCard(),
            SizedBox(height: ResponsiveHelper.h(24)),
            FootballRecordDisciplineCard(data: data),
            SizedBox(height: ResponsiveHelper.h(24)),
            FootballRecentMatchesCard(matches: data.recentMatches),
            SizedBox(height: ResponsiveHelper.h(40)),
          ],
        ),
      ),
    );
  }
}
