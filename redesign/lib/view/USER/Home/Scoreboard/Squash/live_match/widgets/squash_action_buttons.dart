import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_state_models.dart';

class SquashActionButtons extends StatelessWidget {
  final SquashMatchState state;
  final bool canUndo;
  final Function(PlayerSide) onScoreRally;
  final Function(PlayerSide) onRecordStroke;
  final Function(PlayerSide) onRecordNoLet;
  final Function(PlayerSide, String) onRecordConductWarning;
  final Function(PlayerSide) onRecordConductStroke;
  final Function(PlayerSide) onRecordConductGame;
  final VoidCallback onRecordLet;
  final VoidCallback onSwitchServeBox;
  final VoidCallback onUndo;
  final VoidCallback onStartNextGame;

  const SquashActionButtons({
    super.key,
    required this.state,
    required this.canUndo,
    required this.onScoreRally,
    required this.onRecordStroke,
    required this.onRecordNoLet,
    required this.onRecordConductWarning,
    required this.onRecordConductStroke,
    required this.onRecordConductGame,
    required this.onRecordLet,
    required this.onSwitchServeBox,
    required this.onUndo,
    required this.onStartNextGame,
  });

  @override
  Widget build(BuildContext context) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';
    final isFriendly = state.config.isFriendlyRules;

    if (state.isGameFinished && !state.isMatchFinished) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME ${state.currentGameIndex} COMPLETED!',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(14),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(20),
                  vertical: ResponsiveHelper.h(10),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onStartNextGame,
              child: Text(
                'START GAME ${state.currentGameIndex + 1}',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Primary Rally Scoring Buttons (+1 Side A / +1 Side B)
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => onScoreRally(PlayerSide.sideA),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: Flexible(
                  child: Text(
                    '+1 $sideAName',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(10)),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => onScoreRally(PlayerSide.sideB),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: Flexible(
                  child: Text(
                    '+1 $sideBName',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(8)),

        // 2. Secondary Decision Bar (Simplified for Friendly Mode vs Full WSF Suite for Pro Mode)
        if (isFriendly)
          Row(
            children: [
              // Undo Button
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                    side: BorderSide(color: canUndo ? AppColors.primaryGreen : AppColors.borderDark),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: canUndo ? onUndo : null,
                  icon: const Icon(Icons.undo_rounded, size: 16),
                  label: Text(
                    'UNDO',
                    style: AppTypography.bodySm.copyWith(
                      color: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),

              // Let (Replay) Button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coinsGold,
                    side: const BorderSide(color: AppColors.coinsGold),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onRecordLet,
                  child: Text(
                    'LET (Replay)',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.coinsGold,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),

              // Serve Box Toggle Button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.borderDark),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onSwitchServeBox,
                  child: Text(
                    'BOX (${state.currentServeBox == ServeBox.left ? 'L' : 'R'})',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          // Pro Mode Full WSF Referee Controls
          Row(
            children: [
              // Undo Button
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: canUndo ? AppColors.surfaceElevated : AppColors.cardDark,
                  side: BorderSide(color: canUndo ? AppColors.primaryGreen : AppColors.borderDark),
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: canUndo ? onUndo : null,
                icon: Icon(
                  Icons.undo_rounded,
                  color: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                  size: 20,
                ),
                tooltip: 'Undo',
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Let Button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coinsGold,
                    side: const BorderSide(color: AppColors.coinsGold),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onRecordLet,
                  child: Text(
                    'LET',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.coinsGold,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Stroke Button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.infoBlue,
                    side: const BorderSide(color: AppColors.infoBlue),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showStrokeDialog(context),
                  child: Text(
                    'STROKE',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.infoBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Serve Box Toggle Button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.borderDark),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onSwitchServeBox,
                  child: Text(
                    'BOX (${state.currentServeBox == ServeBox.left ? 'L' : 'R'})',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(11),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // WSF Rule 15 Conduct Menu Icon Button
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated,
                  side: const BorderSide(color: AppColors.warning),
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: () => _showConductMenu(context),
                icon: const Icon(Icons.gavel, color: AppColors.warning, size: 18),
                tooltip: 'WSF Rule 15 Conduct',
              ),
            ],
          ),
      ],
    );
  }

  void _showStrokeDialog(BuildContext context) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Award Stroke To', style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary)),
        content: Text('Select which player/side is awarded the stroke penalty point:', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRecordStroke(PlayerSide.sideA);
            },
            child: Text(sideAName, style: const TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRecordStroke(PlayerSide.sideB);
            },
            child: Text(sideBName, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showNoLetDialog(BuildContext context) {
    final sideAName = state.teamA.isNotEmpty ? state.teamA.first.name : 'Side A';
    final sideBName = state.teamB.isNotEmpty ? state.teamB.first.name : 'Side B';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('No Let (Award Rally Win)', style: AppTypography.headlineMd.copyWith(color: AppColors.textPrimary)),
        content: Text('Appeal rejected. Award rally win to non-appealing player:', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRecordNoLet(PlayerSide.sideA);
            },
            child: Text(sideAName, style: const TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRecordNoLet(PlayerSide.sideB);
            },
            child: Text(sideBName, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showConductMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WSF RULE 15: CONDUCT PENALTIES',
              style: AppTypography.headlineSm.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              title: const Text('Conduct Warning', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Issue official warning to player', style: TextStyle(color: Colors.grey, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                onRecordConductWarning(PlayerSide.sideA, 'Unsportsmanlike conduct');
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: AppColors.error),
              title: const Text('Conduct Stroke (Point to Opponent)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Award penalty stroke point to non-offending player', style: TextStyle(color: Colors.grey, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                onRecordConductStroke(PlayerSide.sideB);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_rounded, color: AppColors.primaryGreen),
              title: const Text('Conduct Game (Award Entire Game)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Award entire game to non-offending player', style: TextStyle(color: Colors.grey, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                onRecordConductGame(PlayerSide.sideB);
              },
            ),
            ListTile(
              leading: const Icon(Icons.do_not_disturb_alt, color: AppColors.mutedText),
              title: const Text('No Let (Refuse Appeal)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Reject appeal and award point to non-appealing side', style: TextStyle(color: Colors.grey, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                _showNoLetDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
