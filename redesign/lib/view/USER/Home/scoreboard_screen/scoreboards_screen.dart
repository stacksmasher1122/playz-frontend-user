import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';

// Widgets
import 'widgets/scoreboard_app_bar.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/create_scoreboard_hero.dart';
import 'widgets/create_tournament_card.dart';
import 'package:redesign/view/USER/Tournament/create_tournament/create_tournament_screen.dart';
import 'widgets/live_matches_empty_state.dart';
import 'widgets/live_match_preview_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class ScoreboardHubScreen extends StatefulWidget {
  ScoreboardHubScreen({super.key});

  @override
  State<ScoreboardHubScreen> createState() => _ScoreboardHubScreenState();
}

class _ScoreboardHubScreenState extends State<ScoreboardHubScreen> {
  List<RecoverableMatchItem> _recoverableMatches = [];

  @override
  void initState() {
    super.initState();
    _checkRecoverableMatches();
  }

  Future<void> _checkRecoverableMatches() async {
    final matches = await ScoreboardRecoveryManager.getUnfinishedMatches();
    if (mounted) {
      setState(() {
        _recoverableMatches = matches;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            ScoreboardAppBar(),

            /// UNFINISHED MATCHES RECOVERY SECTION
            if (_recoverableMatches.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2B22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.restore, color: AppColors.accent, size: 20),
                                SizedBox(width: ResponsiveHelper.w(8)),
                                Text(
                                  'Unfinished Matches Found',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: ResponsiveHelper.sp(15),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_recoverableMatches.length}',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(10)),
                        ..._recoverableMatches.map((item) {
                          return Container(
                            margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
                            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.sport == 'Cricket' ? Icons.sports_cricket : Icons.sports_tennis,
                                  color: AppColors.accent,
                                  size: 22,
                                ),
                                SizedBox(width: ResponsiveHelper.w(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: ResponsiveHelper.sp(13),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '${item.subtitle} • ${item.matchType == "SLOT_DEDICATED" ? "Turf Slot" : "Casual"}',
                                        style: GoogleFonts.inter(
                                          color: AppColors.muted,
                                          fontSize: ResponsiveHelper.sp(11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await ScoreboardRecoveryManager.resumeMatch(context, item);
                                    _checkRecoverableMatches();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    'Resume',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.w(6)),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                                  onPressed: () async {
                                    await ScoreboardRecoveryManager.discardMatch(item);
                                    _checkRecoverableMatches();
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

            /// QUICK ACTIONS
            QuickActionsRow(),

            /// CREATE TOURNAMENT CARD
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: CreateTournamentCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
                    );
                  },
                ),
              ),
            ),

            /// CREATE SCOREBOARD
            SliverToBoxAdapter(child: CreateScoreboardHero()),

            /// LIVE MATCHES REEL
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('matches')
                  .where('allPlayers', arrayContains: FirebaseAuth.instance.currentUser?.uid ?? '')
                  .where('status', isEqualTo: 'live')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return LiveMatchesEmptyState();
                }

                final matches = snapshot.data!.docs
                    .map((doc) => CricketMatchModel.fromMap(doc.data()))
                    .toList();

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
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
