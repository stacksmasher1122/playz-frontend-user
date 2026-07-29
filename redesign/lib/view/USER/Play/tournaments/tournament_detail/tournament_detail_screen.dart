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

  bool userHasRegisteredTeam = false;

  @override
  void initState() {
    super.initState();
    _checkUserRegistration();
  }

  Future<void> _checkUserRegistration() async {
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
    ResponsiveHelper.init(context);

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
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOrganizer || isInProgress || (widget.data['status'] == 'completed'))
                    Container(
                      width: double.infinity,
                      height: context.heightPct(6).clamp(48.0, 56.0),
                      margin: EdgeInsets.only(bottom: context.heightPct(2.5)),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                          ),
                        ),
                        icon: Icon(
                          widget.data['status'] == 'completed' ? Icons.emoji_events_rounded : Icons.play_arrow_rounded,
                          color: AppColors.background,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isOrganizer && widget.data['status'] != 'completed'
                                ? "Manage Tournament Matches"
                                : "View Bracket & Results",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(15),
                            ),
                          ),
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
                  SizedBox(height: context.heightPct(2.5)),
                  PrizePoolSection(data: widget.data),
                  SizedBox(height: context.heightPct(2.5)),
                  TeamsSection(
                    tournamentId: widget.tournamentId,
                    maxTeams: (widget.data['format']?['maxTeams'] as num?)?.toInt() ??
                        (widget.data['format']?['participantCount'] as num?)?.toInt() ??
                        (widget.data['format']?['totalTeams'] as num?)?.toInt() ??
                        8,
                    data: widget.data,
                    currentUserId: widget.currentUserId,
                    isOrganizer: isOrganizer,
                    isOpen: isOpen,
                    userHasRegisteredTeam: userHasRegisteredTeam,
                  ),
                  SizedBox(height: context.heightPct(2.5)),
                  BracketsSection(tournamentId: widget.tournamentId, isOrganizer: isOrganizer),
                  SizedBox(height: context.heightPct(2.5)),
                  LeaderboardSection(
                    tournamentId: widget.tournamentId,
                    matchType: widget.data['format']?['matchType'] ?? 'knockout',
                  ),
                  SizedBox(height: context.heightPct(2.5)),
                  WinnersSection(
                    tournamentId: widget.tournamentId,
                    data: widget.data,
                    isOrganizer: isOrganizer,
                  ),
                  SizedBox(height: context.heightPct(5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
