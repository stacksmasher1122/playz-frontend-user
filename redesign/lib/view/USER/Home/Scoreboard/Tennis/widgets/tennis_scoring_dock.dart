import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Tennis Live Scoring & Control Dock designed matching reference UI pixel-for-pixel.
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

  String _truncateName(String name, [int maxChars = 6]) {
    final trimmed = name.trim();
    if (trimmed.length <= maxChars) return trimmed;
    return '${trimmed.substring(0, maxChars)}...';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final String homeTruncated = _truncateName(homeTeamName, 6);
    final String awayTruncated = _truncateName(awayTeamName, 6);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── ROW 1: PRIMARY POINT WINNER BUTTONS ───
          Row(
            children: [
              // Home Team Point Button (Bright Green filled)
              Expanded(
                child: _buildPrimaryPointButton(
                  context: context,
                  label: 'POINT $homeTruncated',
                  subLabel: '+1 Point',
                  bgColor: const Color(0xFF22C55E),
                  textColor: Colors.black,
                  subTextColor: const Color(0xFF042F13),
                  onTap: () => _showPointOutcomeSheet(context, 'A', homeTeamName),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(12)),

              // Away Team Point Button (Dark Slate filled)
              Expanded(
                child: _buildPrimaryPointButton(
                  context: context,
                  label: 'POINT $awayTruncated',
                  subLabel: '+1 Point',
                  bgColor: const Color(0xFF1B2A38),
                  borderColor: const Color(0xFF2D4257),
                  textColor: Colors.white,
                  subTextColor: const Color(0xFF94A3B8),
                  onTap: () => _showPointOutcomeSheet(context, 'B', awayTeamName),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(14)),

          // ─── ROW 2: ACTION CONTROLS GRID (4 COLUMNS) ───
          Row(
            children: [
              // 1st Fault
              Expanded(
                child: _buildActionButtonTile(
                  context: context,
                  label: '1st Fault',
                  iconText: '!',
                  borderColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFF1C1A14),
                  contentColor: const Color(0xFFF59E0B),
                  onTap: onRecordFault,
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(8)),

              // Double Fault
              Expanded(
                child: _buildActionButtonTile(
                  context: context,
                  label: 'Double Fault',
                  iconText: '✕',
                  borderColor: const Color(0xFFDC2626),
                  bgColor: const Color(0xFF241517),
                  contentColor: const Color(0xFFEF4444),
                  onTap: onRecordDoubleFault,
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(8)),

              // Let
              Expanded(
                child: _buildActionButtonTile(
                  context: context,
                  label: 'Let',
                  iconData: Icons.refresh_rounded,
                  borderColor: const Color(0xFF16A34A),
                  bgColor: const Color(0xFF0F2118),
                  contentColor: const Color(0xFF22C55E),
                  onTap: onRecordLet,
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(8)),

              // Undo
              Expanded(
                child: _buildActionButtonTile(
                  context: context,
                  label: 'Undo',
                  iconData: Icons.undo_rounded,
                  borderColor: canUndo ? const Color(0xFF16A34A) : Colors.white.withValues(alpha: 0.08),
                  bgColor: canUndo ? const Color(0xFF0F2118) : Colors.white.withValues(alpha: 0.03),
                  contentColor: canUndo ? const Color(0xFF22C55E) : const Color(0xFF64748B),
                  onTap: canUndo ? onUndo : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryPointButton({
    required BuildContext context,
    required String label,
    required String subLabel,
    required Color bgColor,
    Color? borderColor,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(14),
            horizontal: ResponsiveHelper.w(10),
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: borderColor != null ? Border.all(color: borderColor, width: 1.0) : null,
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
                    fontSize: ResponsiveHelper.sp(13),
                    fontWeight: FontWeight.w900,
                  ).responsive(context),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(2)),
              Text(
                subLabel,
                style: AppTypography.bodySm.copyWith(
                  color: subTextColor,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w600,
                ).responsive(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonTile({
    required BuildContext context,
    required String label,
    String? iconText,
    IconData? iconData,
    required Color borderColor,
    required Color bgColor,
    required Color contentColor,
    VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12),
            horizontal: ResponsiveHelper.w(4),
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            border: Border.all(
              color: isEnabled ? borderColor : Colors.white.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isEnabled ? contentColor : const Color(0xFF64748B), width: 1.5),
                ),
                child: Center(
                  child: iconText != null
                      ? Text(
                          iconText,
                          style: TextStyle(
                            color: isEnabled ? contentColor : const Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : Icon(
                          iconData,
                          size: 14,
                          color: isEnabled ? contentColor : const Color(0xFF64748B),
                        ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(6)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.labelCaps10.copyWith(
                    color: isEnabled ? contentColor : const Color(0xFF64748B),
                    fontSize: ResponsiveHelper.sp(10),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
              ),
            ],
          ),
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
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.w(28)),
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(20),
          vertical: ResponsiveHelper.h(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center top drag handle
            Center(
              child: Container(
                width: ResponsiveHelper.w(36),
                height: ResponsiveHelper.h(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),

            // Header Row: Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Point Details',
                  style: AppTypography.headlineMd.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(20),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: ResponsiveHelper.w(32),
                    height: ResponsiveHelper.w(32),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C222B),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Color(0xFF22C55E),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(6)),

            // Subtitle
            Text(
              'How was the point won by $sideName?',
              style: AppTypography.bodyMd.copyWith(
                color: const Color(0xFF8E8E93),
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.w500,
              ).responsive(context),
            ),

            SizedBox(height: ResponsiveHelper.h(20)),

            // 2x2 Grid of Cards
            Row(
              children: [
                Expanded(
                  child: _buildPointOutcomeCard(
                    context: context,
                    side: side,
                    outcomeType: 'normalPoint',
                    title: 'Normal Point',
                    subtitle: 'Rally won',
                    icon: Icons.check_circle_rounded,
                    isSelected: true,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildPointOutcomeCard(
                    context: context,
                    side: side,
                    outcomeType: 'ace',
                    title: 'Ace',
                    subtitle: 'Unreturned serve',
                    icon: Icons.bolt_rounded,
                    isSelected: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
            Row(
              children: [
                Expanded(
                  child: _buildPointOutcomeCard(
                    context: context,
                    side: side,
                    outcomeType: 'winner',
                    title: 'Winner Shot',
                    subtitle: 'Winning shot',
                    icon: Icons.star_rounded,
                    isSelected: false,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildPointOutcomeCard(
                    context: context,
                    side: side,
                    outcomeType: 'unforcedError',
                    title: 'Opponent Error',
                    subtitle: 'Forced error',
                    icon: Icons.warning_amber_rounded,
                    isSelected: false,
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildPointOutcomeCard({
    required BuildContext context,
    required String side,
    required String outcomeType,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onRecordPoint(side, outcomeType);
        },
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(18),
            horizontal: ResponsiveHelper.w(12),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF141920),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(
              color: isSelected ? const Color(0xFF22C55E) : Colors.white.withValues(alpha: 0.08),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveHelper.w(44),
                height: ResponsiveHelper.w(44),
                decoration: const BoxDecoration(
                  color: Color(0xFF0E2A1C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF22C55E),
                    size: 22,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(12)),
              Text(
                title,
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.h(4)),
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w500,
                ).responsive(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
