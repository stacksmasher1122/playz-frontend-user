import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TennisScoringDock extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final bool canUndo;
  final Function(String winnerSide, String outcomeType) onRecordPoint;
  final VoidCallback onRecordFault;
  final VoidCallback onRecordDoubleFault;
  final VoidCallback onRecordLet;
  final VoidCallback onUndo;

  const TennisScoringDock({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.canUndo,
    required this.onRecordPoint,
    required this.onRecordFault,
    required this.onRecordDoubleFault,
    required this.onRecordLet,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(color: AppColors.cardSurface, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary Point Winner Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'POINT $homeTeamName',
                  subLabel: '+1 Point',
                  color: AppColors.primaryGreen,
                  textColor: Colors.black,
                  onTap: () => _showPointOutcomeSheet(context, 'A', homeTeamName),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12)),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'POINT $awayTeamName',
                  subLabel: '+1 Point',
                  color: AppColors.infoBlue,
                  textColor: Colors.white,
                  onTap: () => _showPointOutcomeSheet(context, 'B', awayTeamName),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(12)),

          // Secondary Service & Control Actions Dock
          Row(
            children: [
              // 1st Serve Fault
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  label: '1st Fault',
                  icon: Icons.error_outline_rounded,
                  color: AppColors.warning,
                  onTap: onRecordFault,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Double Fault
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  label: 'Double Fault',
                  icon: Icons.cancel_outlined,
                  color: AppColors.liveRed,
                  onTap: onRecordDoubleFault,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Let
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  label: 'Let',
                  icon: Icons.replay_rounded,
                  color: Colors.cyanAccent,
                  onTap: onRecordLet,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(6)),

              // Undo
              Expanded(
                child: _buildSecondaryButton(
                  context: context,
                  label: 'Undo',
                  icon: Icons.undo_rounded,
                  color: canUndo ? AppColors.primaryGreen : AppColors.mutedText,
                  onTap: canUndo ? onUndo : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required String subLabel,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(14),
          horizontal: ResponsiveHelper.w(10),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTypography.headlineSm.copyWith(
                  color: textColor,
                  fontSize: context.responsiveFont(14),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(2)),
            Text(
              subLabel,
              style: AppTypography.bodySm.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.h(10),
          horizontal: ResponsiveHelper.w(2),
        ),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: 0.12)
              : AppColors.cardSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isEnabled ? color.withValues(alpha: 0.4) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isEnabled ? color : AppColors.mutedText,
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTypography.labelCaps10.copyWith(
                  color: isEnabled ? color : AppColors.mutedText,
                  fontSize: context.responsiveFont(10),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPointOutcomeSheet(
      BuildContext context, String side, String sideName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.w(24)),
          ),
        ),
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Point Details for $sideName',
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(6)),
            Text(
              'Specify how the point was scored:',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(13),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(20)),
            Wrap(
              spacing: ResponsiveHelper.w(10),
              runSpacing: ResponsiveHelper.h(10),
              children: [
                _buildOutcomeOption(
                    context, side, 'normalPoint', 'Normal Point', Icons.check_circle_outline),
                _buildOutcomeOption(
                    context, side, 'ace', 'Ace', Icons.bolt_rounded),
                _buildOutcomeOption(
                    context, side, 'winner', 'Winner Shot', Icons.star_rounded),
                _buildOutcomeOption(
                    context, side, 'unforcedError', 'Opponent Error', Icons.warning_amber_rounded),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeOption(
    BuildContext context,
    String side,
    String outcomeType,
    String label,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onRecordPoint(side, outcomeType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16),
          vertical: ResponsiveHelper.h(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 18),
            SizedBox(width: ResponsiveHelper.w(8)),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
