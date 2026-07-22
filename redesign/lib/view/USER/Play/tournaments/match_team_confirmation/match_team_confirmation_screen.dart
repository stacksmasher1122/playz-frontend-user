import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../model/User_Models/Tournament_Model/tournament_team_model.dart';
import 'widgets/facing_team_card.dart';
import '../match_rules_confirmation/match_rules_confirmation_screen.dart';

class MatchTeamConfirmationScreen extends StatefulWidget {
  final String tournamentId;
  final String matchId;
  final String teamAId;
  final String teamBId;

  const MatchTeamConfirmationScreen({
    super.key,
    required this.tournamentId,
    required this.matchId,
    required this.teamAId,
    required this.teamBId,
  });

  @override
  State<MatchTeamConfirmationScreen> createState() => _MatchTeamConfirmationScreenState();
}

class _MatchTeamConfirmationScreenState extends State<MatchTeamConfirmationScreen> {
  TournamentTeamModel? teamA;
  TournamentTeamModel? teamB;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    try {
      final docA = await FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).collection('teams').doc(widget.teamAId).get();
      final docB = await FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).collection('teams').doc(widget.teamBId).get();

      if (docA.exists && docB.exists) {
        teamA = _parseTeam(docA);
        teamB = _parseTeam(docB);
      } else {
        error = "Could not load one or both teams.";
      }
    } catch (e) {
      error = "Error loading teams: $e";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  TournamentTeamModel _parseTeam(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<TournamentPlayerModel> players = [];
    if (data['players'] != null) {
      for (var p in data['players']) {
        players.add(TournamentPlayerModel.fromMap(Map<String, dynamic>.from(p)));
      }
    }
    return TournamentTeamModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      logoUrl: data['logoUrl'],
      registeredBy: data['registeredBy'] ?? '',
      players: players,
      paymentStatus: data['paymentStatus'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text("Confirm Teams", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : (error != null)
            ? Center(child: Text(error!, style: AppTypography.bodyMd.copyWith(color: AppColors.error)))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                      child: Column(
                        children: [
                          FacingTeamCard(team: teamA!, sideTitle: "TEAM A"),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                            child: Text("VS", style: AppTypography.headlineSm.copyWith(color: AppColors.muted)),
                          ),
                          FacingTeamCard(team: teamB!, sideTitle: "TEAM B"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.card)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                        ),
                        onPressed: () {
                          Get.to(() => MatchRulesConfirmationScreen(
                            tournamentId: widget.tournamentId,
                            bracketMatchId: widget.matchId,
                            teamA: teamA!,
                            teamB: teamB!,
                          ));
                        },
                        child: Text(
                          "Next",
                          style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
