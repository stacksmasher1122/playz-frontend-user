import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../model/User_Models/Tournament_Model/tournament_team_model.dart';
import '../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import '../../../../../model/User_Models/Home_Models/Scoreboard_Model/badminton_state_models.dart';
import '../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'widgets/rules_summary_card.dart';

class MatchRulesConfirmationScreen extends StatefulWidget {
  final String tournamentId;
  final String bracketMatchId;
  final TournamentTeamModel teamA;
  final TournamentTeamModel teamB;

  const MatchRulesConfirmationScreen({
    super.key,
    required this.tournamentId,
    required this.bracketMatchId,
    required this.teamA,
    required this.teamB,
  });

  @override
  State<MatchRulesConfirmationScreen> createState() => _MatchRulesConfirmationScreenState();
}

class _MatchRulesConfirmationScreenState extends State<MatchRulesConfirmationScreen> {
  Map<String, dynamic>? tournamentData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchTournamentRules();
  }

  Future<void> _fetchTournamentRules() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('tournaments').doc(widget.tournamentId).get();
      if (doc.exists) {
        tournamentData = doc.data();
      } else {
        error = "Tournament not found.";
      }
    } catch (e) {
      error = "Error loading rules: $e";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startMatch() {
    if (tournamentData == null) return;

    // We reuse the existing BadmintonController
    final badmintonController = Get.put(BadmintonController());

    List<FriendModel> teamARoster = widget.teamA.players.map((p) => FriendModel(
      email: p.userId, // use userId as unique identifier
      fullName: p.name,
      profileImageUrl: p.profileImageUrl,
    )).toList();

    List<FriendModel> teamBRoster = widget.teamB.players.map((p) => FriendModel(
      email: p.userId,
      fullName: p.name,
      profileImageUrl: p.profileImageUrl,
    )).toList();

    Map<String, dynamic> sportRules = tournamentData!['format']?['sportRules'] ?? {};

    badmintonController.createAndStartTournamentMatch(
      tId: widget.tournamentId,
      bMatchId: widget.bracketMatchId,
      teamA: teamARoster,
      teamB: teamBRoster,
      sportRules: sportRules,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text("Confirm Rules", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
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
                          RulesSummaryCard(
                            sportRules: tournamentData?['format']?['sportRules'] ?? {},
                          ),
                          // Additional Match Details Preview (Optional)
                          SizedBox(height: ResponsiveHelper.h(24)),
                          Text(
                            "Match Preview",
                            style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
                          ),
                          SizedBox(height: ResponsiveHelper.h(12)),
                          Container(
                            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Text(widget.teamA.name, textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary))),
                                Text("VS", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                                Expanded(child: Text(widget.teamB.name, textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary))),
                              ],
                            ),
                          )
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
                        onPressed: _startMatch,
                        child: Text(
                          "Start Match",
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
