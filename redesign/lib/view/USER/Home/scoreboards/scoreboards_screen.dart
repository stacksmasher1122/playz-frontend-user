import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';

// Widgets
import 'widgets/scoreboard_app_bar.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/create_scoreboard_hero.dart';
import 'widgets/live_matches_empty_state.dart';
import 'widgets/live_match_preview_card.dart';

const kBg = AppColors.background;

class ScoreboardHubScreen extends StatefulWidget {
  const ScoreboardHubScreen({super.key});

  @override
  State<ScoreboardHubScreen> createState() => _ScoreboardHubScreenState();
}

class _ScoreboardHubScreenState extends State<ScoreboardHubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const ScoreboardAppBar(),

            /// QUICK ACTIONS
            const QuickActionsRow(),

            /// CREATE SCOREBOARD
            const SliverToBoxAdapter(child: CreateScoreboardHero()),

            /// LIVE MATCHES REEL
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('matches')
                  .where('allPlayers', arrayContains: FirebaseAuth.instance.currentUser?.uid ?? '')
                  .where('status', isEqualTo: 'live')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const LiveMatchesEmptyState();
                }

                final matches = snapshot.data!.docs
                    .map((doc) => CricketMatchModel.fromMap(doc.data()))
                    .toList();

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => LiveMatchPreviewCard(match: matches[index]),
                      childCount: matches.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
