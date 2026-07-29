import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../model/User_Models/Tournament_Model/tournament_team_model.dart';
import '../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Confirm Rules",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : (error != null)
            ? Center(
                child: Text(
                  error!,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.error,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(context.widthPct(4)),
                      child: Column(
                        children: [
                          RulesSummaryCard(
                            sportRules: tournamentData?['format']?['sportRules'] ?? {},
                          ),
                          // Additional Match Details Preview
                          SizedBox(height: context.heightPct(3)),
                          Text(
                            "Match Preview",
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.heightPct(1.5)),
                          Container(
                            padding: EdgeInsets.all(context.widthPct(4)),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                              border: Border.all(color: AppColors.borderDark),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.teamA.name,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: context.responsiveFont(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: context.widthPct(2)),
                                Text(
                                  "VS",
                                  style: AppTypography.labelCaps10.copyWith(
                                    color: AppColors.muted,
                                    fontSize: context.responsiveFont(12),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: context.widthPct(2)),
                                Expanded(
                                  child: Text(
                                    widget.teamB.name,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: context.responsiveFont(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(context.widthPct(4)),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.borderDark)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: context.heightPct(6).clamp(48.0, 56.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                          ),
                        ),
                        onPressed: _startMatch,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Start Match",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(16),
                            ),
                          ),
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
