import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_typography.dart';
import '../bracket_matchmaking/bracket_matchmaking_screen.dart';

import 'widgets/tournament_header.dart';
import 'widgets/format_summary.dart';
import 'widgets/prize_pool_section.dart';
import 'widgets/teams_section.dart';
import 'widgets/brackets_section.dart';
import 'widgets/leaderboard_section.dart';
import 'widgets/winners_section.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TournamentDetailScreen extends StatefulWidget {
  final String tournamentId;
  final Map<String, dynamic> data;
  final String currentUserId;

  const TournamentDetailScreen({
    super.key,
    required this.tournamentId,
    required this.data,
    required this.currentUserId,
  });

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {

  bool get isOrganizer => widget.data['organizerId'] == widget.currentUserId;
  bool get isOpen => widget.data['status'] == 'registration_open';
  bool get isInProgress => widget.data['status'] == 'in_progress';

  // Future checks:
  bool userHasRegisteredTeam = false;

  @override
  void initState() {
    super.initState();
    _checkUserRegistration();
  }

  Future<void> _checkUserRegistration() async {
    // B3 Fix: Get current auth user ID dynamically
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final query = await FirebaseFirestore.instance
      .collection('tournaments')
      .doc(widget.tournamentId)
      .collection('teams')
      .where('registeredBy', isEqualTo: currentUserId)
      .get();

    if (mounted) {
      setState(() {
        userHasRegisteredTeam = query.docs.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          TournamentHeader(
            data: widget.data,
            onBack: () => Get.back(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // D4 Fix: Allow both organizer and referees to access bracket to manage/drive their matches
                  if (isOrganizer || isInProgress)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(24)),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                        ),
                        icon: Icon(Icons.play_arrow, color: AppColors.background),
                        label: Text(
                          isOrganizer ? "Manage Tournament Matches" : "View Bracket",
                          style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () {
                          Get.to(() => BracketMatchmakingScreen(
                            tournamentId: widget.tournamentId,
                            isOrganizer: isOrganizer,
                          ));
                        },
                      ),
                    ),
                  FormatSummary(data: widget.data),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  PrizePoolSection(data: widget.data),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  TeamsSection(
                    tournamentId: widget.tournamentId,
                    maxTeams: widget.data['format']['teamSize'] ?? 0,
                    data: widget.data,
                    currentUserId: widget.currentUserId,
                    isOrganizer: isOrganizer,
                    isOpen: isOpen,
                    userHasRegisteredTeam: userHasRegisteredTeam,
                  ),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  BracketsSection(tournamentId: widget.tournamentId, isOrganizer: isOrganizer),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  LeaderboardSection(
                    tournamentId: widget.tournamentId,
                    matchType: widget.data['format']?['matchType'] ?? 'knockout',
                  ),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  WinnersSection(
                    tournamentId: widget.tournamentId,
                    data: widget.data,
                    isOrganizer: isOrganizer
                  ),
                  SizedBox(height: ResponsiveHelper.h(40)), // padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
