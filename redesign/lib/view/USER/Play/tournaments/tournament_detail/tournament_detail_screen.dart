import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/tournament_header.dart';
import 'widgets/format_summary.dart';
import 'widgets/prize_pool_section.dart';
import 'widgets/teams_section.dart';
import 'widgets/brackets_section.dart';
import 'widgets/leaderboard_section.dart';

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
  // Sometimes status may not be strictly 'registration_open' or missing in dummy data,
  // Let's assume it's open if it's not explicitly 'completed' or 'cancelled'.
  bool get isOpen {
    final status = widget.data['status'];
    if (status == null) return true; // Default to open if missing
    return status == 'registration_open' || status == 'open' || status == 'published' || status == 'upcoming';
  }

  // Future checks:
  bool userHasRegisteredTeam = false;

  @override
  void initState() {
    super.initState();
    _checkUserRegistration();
  }

  Future<void> _checkUserRegistration() async {
    final query = await FirebaseFirestore.instance
      .collection('tournaments')
      .doc(widget.tournamentId)
      .collection('teams')
      .where('registeredBy', isEqualTo: widget.currentUserId)
      .get();

    if (mounted && query.docs.isNotEmpty) {
      setState(() {
        userHasRegisteredTeam = true;
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
                  LeaderboardSection(tournamentId: widget.tournamentId),
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
