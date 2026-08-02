import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class CricketDetailScreen extends StatefulWidget {
  final SportStatModel? stat;

  const CricketDetailScreen({super.key, this.stat});

  @override
  State<CricketDetailScreen> createState() => _CricketDetailScreenState();
}

class _CricketDetailScreenState extends State<CricketDetailScreen> {
  CricketStatsDetailModel? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .get();
        if (doc.exists && doc.data()?['cricketStats'] != null) {
          final stats = doc.data()!['cricketStats'] as Map<String, dynamic>;
          setState(() {
            _data = CricketStatsDetailModel.fromFirestore(stats);
            _loading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching cricket stats: $e');
    }
    // Fallback to sample data if Firestore fetch fails or no stats exist
    setState(() {
      _data = CricketStatsDetailModel.getSampleData();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MyStatsAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: ResponsiveHelper.h(10)),
                  CricketHeroHeader(data: _data!),
                  SizedBox(height: ResponsiveHelper.h(20)),
                  CricketBattingCard(data: _data!),
                  SizedBox(height: ResponsiveHelper.h(14)),
                  CricketMilestonesFormatCard(data: _data!),
                  SizedBox(height: ResponsiveHelper.h(14)),
                  CricketBowlingCard(data: _data!),
                  SizedBox(height: ResponsiveHelper.h(14)),
                  CricketFieldingRatingCard(data: _data!),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  const CricketTrendsChart(),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  CricketRecentMatchesCard(matches: _data!.recentMatches),
                  SizedBox(height: ResponsiveHelper.h(40)),
                ],
              ),
            ),
    );
  }
}
