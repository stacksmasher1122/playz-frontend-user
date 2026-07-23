import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'player_selection_sheet.dart';

class ScoringConsole extends StatelessWidget {
  final BasketballMatchState state;
  final BasketballController controller;

  const ScoringConsole({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTeamConsole(context, 'home', state.homeTeam)),
              const SizedBox(width: AppDimensions.paddingMd),
              Expanded(child: _buildTeamConsole(context, 'away', state.awayTeam)),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.engine.canUndo ? controller.undo : null,
              icon: const Icon(Icons.undo),
              label: Text('UNDO LAST ACTION', style: AppTypography.labelCaps),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.surface.withOpacity(0.5),
                disabledForegroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  side: const BorderSide(color: AppColors.card),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamConsole(BuildContext context, String teamId, BasketballTeamState team) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        children: [
          Text(team.teamName, style: AppTypography.headlineSm, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppDimensions.paddingMd),
          _buildScoreButton(context, teamId, '+2', EventType.fieldGoalMade, 2),
          const SizedBox(height: AppDimensions.paddingSm),
          _buildScoreButton(context, teamId, '+3', EventType.fieldGoalMade, 3),
          const SizedBox(height: AppDimensions.paddingSm),
          _buildScoreButton(context, teamId, 'Miss', EventType.fieldGoalMissed, 0, isMuted: true),
          const Divider(color: AppColors.surface, height: 24),
          _buildScoreButton(context, teamId, 'FT Make', EventType.freeThrowMade, 1),
          const SizedBox(height: AppDimensions.paddingSm),
          _buildScoreButton(context, teamId, 'FT Miss', EventType.freeThrowMissed, 0, isMuted: true),
        ],
      ),
    );
  }

  Widget _buildScoreButton(BuildContext context, String teamId, String label, EventType type, int points, {bool isMuted = false}) {
    return SizedBox(
      width: double.infinity,
      height: 64, // Min 64x64dp target
      child: ElevatedButton(
        onPressed: () {
          _showPlayerSelection(context, teamId, (playerId) {
            controller.dispatchEvent(BasketballEvent(
              id: const Uuid().v4(),
              type: type,
              teamId: teamId,
              playerId: playerId,
              quarter: state.currentQuarter,
              gameClockRemaining: state.gameClockSeconds,
              points: points,
              timestamp: DateTime.now(),
            ));
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isMuted ? AppColors.surface : AppColors.accent.withOpacity(0.1),
          foregroundColor: isMuted ? Colors.white70 : AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppTypography.labelCaps.copyWith(
            fontSize: 18,
            color: isMuted ? Colors.white70 : AppColors.accent,
          ),
        ),
      ),
    );
  }

  void _showPlayerSelection(BuildContext context, String teamId, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => PlayerSelectionSheet(
        team: teamId == 'home' ? state.homeTeam : state.awayTeam,
        onSelected: (playerId) {
          Navigator.pop(context);
          onSelected(playerId);
        },
      ),
    );
  }
}
