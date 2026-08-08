import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Improved Issue Card Modal Bottom Sheet matching attached 4-panel UI workflow.
class CardWorkflow extends StatefulWidget {
  final MatchEngine engine;

  const CardWorkflow({super.key, required this.engine});

  @override
  State<CardWorkflow> createState() => _CardWorkflowState();
}

class _CardWorkflowState extends State<CardWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? selectedPlayer;

  int step = 0; // 0: Select Team, 1: Select Player, 2: Select Card Type

  String _getTeamInitials(String name) {
    final cleanName = name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    final words = cleanName.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length >= 3) {
      return (words[0][0] + words[1][0] + words[2][0]).toUpperCase();
    } else if (cleanName.length >= 3) {
      return cleanName.substring(0, 3).toUpperCase();
    } else {
      return cleanName.toUpperCase();
    }
  }

  String _getPlayerInitial(String name) {
    if (name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(14.0)),
              decoration: BoxDecoration(
                color: AppColors.mutedText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Header Row (Title & Close Icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Issue Card',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.mutedText,
                  size: ResponsiveHelper.w(22.0),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12.0)),

          // Body Content Based on Step
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (step == 0) return _buildTeamSelection(context);
    if (step == 1) return _buildPlayerSelection(context);
    return _buildCardTypeSelection(context);
  }

  // ─── STEP 0: TEAM SELECTION (PANEL 1) ───
  Widget _buildTeamSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ResponsiveHelper.h(8.0)),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildTeamSelectCard(
                  context,
                  team: widget.engine.state.homeTeam,
                  side: TeamSide.home,
                  isSelected: selectedSide == TeamSide.home,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(14.0)),
              Expanded(
                child: _buildTeamSelectCard(
                  context,
                  team: widget.engine.state.awayTeam,
                  side: TeamSide.away,
                  isSelected: selectedSide == TeamSide.away,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),
      ],
    );
  }

  Widget _buildTeamSelectCard(
    BuildContext context, {
    required MatchTeam team,
    required TeamSide side,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedSide = side;
            step = 1;
          });
        },
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18.0)),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.borderDark,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle Avatar with Initials
              Container(
                width: ResponsiveHelper.w(64.0),
                height: ResponsiveHelper.w(64.0),
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getTeamInitials(team.name),
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(18.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ).responsive(context),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(14.0)),

              // Team Name
              Text(
                team.name,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSm.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── STEP 1: PLAYER SELECTION (PANEL 2) ───
  Widget _buildPlayerSelection(BuildContext context) {
    final MatchTeam team = selectedSide == TeamSide.home
        ? widget.engine.state.homeTeam
        : widget.engine.state.awayTeam;

    final List<MatchPlayer> pitchPlayers = team.squad
        .where((p) => p.isOnPitch && !p.isSentOff)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Player',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(10.0)),

        Expanded(
          child: ListView.builder(
            itemCount: pitchPlayers.length,
            itemBuilder: (ctx, i) {
              final player = pitchPlayers[i];
              return Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlayer = player;
                        step = 2;
                      });
                    },
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(14.0),
                        vertical: ResponsiveHelper.h(12.0),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Row(
                        children: [
                          // Circle Avatar Initial
                          Container(
                            width: ResponsiveHelper.w(36.0),
                            height: ResponsiveHelper.w(36.0),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getPlayerInitial(player.name),
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ResponsiveHelper.sp(14.0),
                                ).responsive(context),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(12.0)),

                          // Player Name
                          Expanded(
                            child: Text(
                              player.name,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveHelper.sp(14.0),
                              ).responsive(context),
                            ),
                          ),

                          // Shirt Number
                          Text(
                            '#${player.number}',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.mutedText,
                              fontSize: ResponsiveHelper.sp(13.0),
                              fontFamily: 'JetBrains Mono',
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── STEP 2: CARD TYPE SELECTION (PANEL 3) ───
  Widget _buildCardTypeSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Card Type',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
        SizedBox(height: ResponsiveHelper.h(14.0)),

        Expanded(
          child: Row(
            children: [
              // Yellow Card Card
              Expanded(
                child: _buildCardTypeTile(
                  context,
                  title: 'YELLOW',
                  subtitle: 'Caution',
                  backgroundColor: AppColors.warning, // Vibrant Yellow
                  contentColor: AppColors.background,
                  onTap: () => _confirmCard(EventType.yellowCard),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Red Card Card
              Expanded(
                child: _buildCardTypeTile(
                  context,
                  title: 'RED',
                  subtitle: 'Send Off',
                  backgroundColor: AppColors.error, // Vibrant Red
                  contentColor: AppColors.textPrimary,
                  onTap: () => _confirmCard(EventType.redCard),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16.0)),
      ],
    );
  }

  Widget _buildCardTypeTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color contentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card Outline Icon
              Icon(
                Icons.style_rounded,
                color: contentColor,
                size: ResponsiveHelper.w(48.0),
              ),
              SizedBox(height: ResponsiveHelper.h(14.0)),

              // Title
              Text(
                title,
                style: AppTypography.displayLg.copyWith(
                  color: contentColor,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(4.0)),

              // Subtitle
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: contentColor.withValues(alpha: 0.8),
                  fontSize: ResponsiveHelper.sp(13.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCard(EventType type) {
    final controller = Get.find<FootballController>();
    controller.processCard(selectedSide!, selectedPlayer!, type, "Foul");
    Navigator.pop(context);
  }
}
