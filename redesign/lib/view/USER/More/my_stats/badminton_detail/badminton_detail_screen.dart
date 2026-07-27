import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/sport_stat_model.dart';
import 'package:redesign/model/User_Models/More_Models/badminton_stats_detail_model.dart';

import '../my_stats/widgets/my_stats_app_bar.dart';
import 'widgets/badminton_hero_header.dart';
import 'widgets/badminton_record_diff_card.dart';
import 'widgets/badminton_metrics_grid_card.dart';
import 'widgets/badminton_style_format_card.dart';
import 'widgets/badminton_trends_chart.dart';
import 'widgets/badminton_recent_matches_card.dart';

class BadmintonDetailScreen extends StatelessWidget {
  final SportStatModel? stat;

  const BadmintonDetailScreen({super.key, this.stat});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final data = BadmintonStatsDetailModel.getSampleData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MyStatsAppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: ResponsiveHelper.h(10)),
            BadmintonHeroHeader(data: data),
            SizedBox(height: ResponsiveHelper.h(20)),
            BadmintonRecordDiffCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            BadmintonMetricsGridCard(data: data),
            SizedBox(height: ResponsiveHelper.h(14)),
            BadmintonStyleFormatCard(data: data),
            SizedBox(height: ResponsiveHelper.h(24)),
            const BadmintonTrendsChart(),
            SizedBox(height: ResponsiveHelper.h(24)),
            BadmintonRecentMatchesCard(matches: data.recentMatches),
            SizedBox(height: ResponsiveHelper.h(40)),
          ],
        ),
      ),
    );
  }
}
