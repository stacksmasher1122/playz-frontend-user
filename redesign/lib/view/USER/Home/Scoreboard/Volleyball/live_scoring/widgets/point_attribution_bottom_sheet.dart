import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointAttributionBottomSheet extends StatelessWidget {
  final String scoringTeamName;
  final Function(String reason) onPointAwarded;

  const PointAttributionBottomSheet({
    super.key,
    required this.scoringTeamName,
    required this.onPointAwarded,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    
    final scoringPlays = ['Attack Kill', 'Service Ace', 'Block Point'];
    final opponentFaults = ['Net Touch', 'Out of Bounds', 'Double Contact', 'Four Touches', 'Foot Fault (Serve)', 'Lift / Carry', 'Center Line Violation'];

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AWARD POINT TO', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.muted),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            Text(scoringTeamName, style: AppTypography.headlineSm.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            
            Text('SCORING PLAY', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scoringPlays.map((play) => _buildChip(context, play, true)).toList(),
            ),
            
            SizedBox(height: 24),
            Text('OPPONENT FAULT', style: AppTypography.labelCaps10.copyWith(color: AppColors.error, letterSpacing: 1.5)),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: opponentFaults.map((fault) => _buildChip(context, fault, false)).toList(),
            ),
            
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(56),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPointAwarded("Point"); // Generic point
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.outlineVariant),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                ),
                child: Text('QUICK POINT (NO REASON)', style: AppTypography.headlineMd.copyWith(color: Colors.white)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String text, bool isScoring) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onPointAwarded(text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
        decoration: BoxDecoration(
          color: isScoring ? AppColors.accent.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
          border: Border.all(color: isScoring ? AppColors.accent.withValues(alpha: 0.5) : AppColors.error.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(100)),
        ),
        child: Text(
          text,
          style: AppTypography.bodyMd.copyWith(color: isScoring ? AppColors.accent : AppColors.error),
        ),
      ),
    );
  }
}
