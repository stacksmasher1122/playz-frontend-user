import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../register_team/register_team_screen.dart';
import 'widgets/tournament_header.dart';
import 'widgets/format_summary.dart';
import 'widgets/prize_pool_section.dart';
import 'widgets/teams_section.dart';
import 'widgets/brackets_section.dart';

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
                  TeamsSection(tournamentId: widget.tournamentId, maxTeams: widget.data['format']['teamSize'] ?? 0), // Will list teams
                  SizedBox(height: ResponsiveHelper.h(24)),
                  BracketsSection(tournamentId: widget.tournamentId, isOrganizer: isOrganizer),
                  SizedBox(height: ResponsiveHelper.h(100)), // padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: (isOpen && !userHasRegisteredTeam && !isOrganizer)
        ? _buildRegisterCTA()
        : null,
    );
  }

  Widget _buildRegisterCTA() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.card)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            minimumSize: Size(double.infinity, ResponsiveHelper.h(56)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
          ),
          onPressed: () {
            Get.to(() => RegisterTeamScreen(
              tournamentId: widget.tournamentId,
              tournamentData: widget.data,
              currentUserId: widget.currentUserId,
            ));
          },
          child: Text(
            "REGISTER TEAM",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
