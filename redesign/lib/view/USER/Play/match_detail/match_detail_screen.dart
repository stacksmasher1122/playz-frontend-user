import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/match_detail_hero.dart';
import 'widgets/match_slots_card.dart';
import 'widgets/competitiveness_card.dart';
import 'widgets/player_pool_section.dart';
import 'widgets/match_location_card.dart';
import 'widgets/match_rules_section.dart';
import 'widgets/host_reliability_card.dart';
import 'widgets/match_join_bar.dart';

class MatchDetailScreen extends StatelessWidget {
  final String sport;
  final String type;
  final String time;
  final String price;
  final int currentPlayers;
  final int maxPlayers;
  final String address;
  final String hostName;
  final String hostAvatar;
  final int hostXp;
  final List<String>? turfImages;

  const MatchDetailScreen({
    super.key,
    this.sport = 'Football',
    this.type = 'Casual',
    this.time = 'Today, 18:00',
    this.price = '₹100',
    this.currentPlayers = 6,
    this.maxPlayers = 10,
    this.address = 'FC Road, Shivajinagar, Pune, Maharashtra 411005',
    this.hostName = 'Host Player',
    this.hostAvatar = 'https://i.pravatar.cc/150?img=1',
    this.hostXp = 2500,
    this.turfImages,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              MatchDetailHero(
                images: turfImages,
                sport: sport,
                type: type,
                time: time,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveHelper.w(16),
                    ResponsiveHelper.h(16),
                    ResponsiveHelper.w(16),
                    ResponsiveHelper.h(110),
                  ),
                  child: Column(
                    children: [
                      MatchSlotsCard(
                        currentPlayers: currentPlayers,
                        maxPlayers: maxPlayers,
                      ),
                      SizedBox(height: 16),
                      const CompetitivenessCard(score: 94),
                      SizedBox(height: 16),
                      PlayerPoolSection(
                        hostName: hostName,
                        hostAvatar: hostAvatar,
                        hostXp: hostXp,
                      ),
                      SizedBox(height: 16),
                      MatchLocationCard(
                        venueName: address.contains('-') ? address.split('-').first.trim() : address,
                        address: address,
                      ),
                      SizedBox(height: 16),
                      const MatchRulesSection(),
                      SizedBox(height: 16),
                      const HostReliabilityCard(reliabilityScore: 98),
                    ],
                  ),
                ),
              ),
            ],
          ),
          MatchJoinBar(price: price),
        ],
      ),
    );
  }
}
