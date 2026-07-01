import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

// Modular Widgets
import 'widgets/rankings_app_bar.dart';
import 'widgets/user_rank_card.dart';
import 'widgets/scope_tabs.dart';
import 'widgets/sport_filter_row.dart';
import 'widgets/season_prize_card.dart';
import 'widgets/quick_stats_row.dart';
import 'widgets/league_sections.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;

class RankingsScreen extends StatefulWidget {
  RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  int scopeIndex = 0;
  int sportIndex = 0;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
           slivers: [
            RankingsAppBar(),
            SliverToBoxAdapter(child: UserRankCard()),
            SliverToBoxAdapter(
              child: ScopeTabs(
                selected: scopeIndex,
                onChanged: (i) => setState(() => scopeIndex = i),
              ),
            ),
            SliverToBoxAdapter(
              child: SportFilterRow(
                selected: sportIndex,
                onChanged: (i) => setState(() => sportIndex = i),
              ),
            ),
            SliverToBoxAdapter(child: SeasonPrizeCard()),
            SliverToBoxAdapter(child: QuickStatsRow()),
            SliverToBoxAdapter(child: GoldLeagueSection()),
            SliverToBoxAdapter(child: SilverLeagueSection()),
            SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }
}
