import 'package:flutter/material.dart';
import 'match_detail_constants.dart';
import 'widgets/match_detail_hero.dart';
import 'widgets/match_slots_card.dart';
import 'widgets/competitiveness_card.dart';
import 'widgets/player_pool_section.dart';
import 'widgets/match_location_card.dart';
import 'widgets/match_rules_section.dart';
import 'widgets/host_reliability_card.dart';
import 'widgets/match_join_bar.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchDetailScreen extends StatelessWidget {
  MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final padding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: MatchDetailColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              MatchDetailHero(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, 24, padding, 120),
                  child: Column(
                    children: [
                      MatchSlotsCard(),
                      SizedBox(height: 20),
                      CompetitivenessCard(),
                      SizedBox(height: 28),
                      PlayerPoolSection(),
                      SizedBox(height: 28),
                      MatchLocationCard(),
                      SizedBox(height: 28),
                      MatchRulesSection(),
                      SizedBox(height: 28),
                      HostReliabilityCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          MatchJoinBar(),
        ],
      ),
    );
  }
}
