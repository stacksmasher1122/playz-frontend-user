import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TtScoringDock extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final bool canUndo;
  final Function(String winnerSide, String outcomeType) onRecordPoint;
  final VoidCallback onRecordServiceFault;
  final VoidCallback onRecordLet;
  final VoidCallback onUndo;

  const TtScoringDock({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.canUndo,
    required this.onRecordPoint,
    required this.onRecordServiceFault,
    required this.onRecordLet,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary Point Winner Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildPointButton(
                  context,
                  teamName: homeTeamName,
                  side: 'A',
                  color: AppColors.error,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Expanded(
                child: _buildPointButton(
                  context,
                  teamName: awayTeamName,
                  side: 'B',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),

          // Secondary Action Buttons Row (Fault, Let, Undo)
          Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  label: 'FAULT',
                  icon: Icons.error_outline_rounded,
                  color: AppColors.warning,
                  onTap: onRecordServiceFault,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  label: 'LET',
                  icon: Icons.replay_rounded,
                  color: AppColors.infoBlue,
                  onTap: onRecordLet,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8)),
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  label: 'UNDO',
                  icon: Icons.undo_rounded,
                  color: canUndo ? AppColors.textPrimary : AppColors.mutedText,
                  isDisabled: !canUndo,
                  onTap: canUndo ? onUndo : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointButton(
    BuildContext context, {
    required String teamName,
    required String side,
    required Color color,
  }) {
    return GestureDetector(
      onLongPress: () => _showPointOutcomeSheet(context, teamName, side),
      child: ElevatedButton(
        onPressed: () => onRecordPoint(side, 'normalPoint'),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.2),
          foregroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(14),
            horizontal: ResponsiveHelper.w(8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            side: BorderSide(color: color, width: 1.5),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'POINT',
              style: AppTypography.labelCaps.copyWith(
                color: color,
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            Text(
              teamName,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _showPointOutcomeSheet(
      BuildContext context, String teamName, String side) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(20)),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECORD SPECIAL POINT FOR $teamName',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.primaryGreen,
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(16)),
              ListTile(
                leading: const Icon(Icons.flash_on_rounded, color: AppColors.coinsGold),
                title: const Text('ACE (Service Winner)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  onRecordPoint(side, 'ace');
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports_baseball_rounded, color: AppColors.infoBlue),
                title: const Text('EDGE BALL (Net/Edge Touch)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  onRecordPoint(side, 'edgeBall');
                },
              ),
              ListTile(
                leading: const Icon(Icons.error_outline_rounded, color: AppColors.error),
                title: const Text('UNFORCED ERROR BY OPPONENT', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  onRecordPoint(side, 'unforcedError');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    bool isDisabled = false,
    VoidCallback? onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? AppColors.surface
            : color.withValues(alpha: 0.15),
        foregroundColor: isDisabled ? AppColors.mutedText : color,
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(10),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          side: BorderSide(
            color: isDisabled
                ? AppColors.borderDark
                : color.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isDisabled ? AppColors.mutedText : color),
          SizedBox(width: ResponsiveHelper.w(4)),
          Text(
            label,
            style: AppTypography.labelCaps.copyWith(
              color: isDisabled ? AppColors.mutedText : color,
              fontSize: context.responsiveFont(11),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
