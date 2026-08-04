import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TennisMoreActionsSheet extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final Function(String retiringSide) onRetirePlayer;
  final VoidCallback onChangeServer;

  const TennisMoreActionsSheet({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.onRetirePlayer,
    required this.onChangeServer,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
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
            'Match Actions & Controls',
            style: AppTypography.headlineSora.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(20),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(6)),
          Text(
            'Select an administrative action for this match:',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.mutedText,
              fontSize: context.responsiveFont(14),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24)),

          // 1. Manual Server Change
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
              child: const Icon(
                Icons.swap_calls_rounded,
                color: AppColors.primaryGreen,
              ),
            ),
            title: Text(
              'Change Server',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Manually alternate server side',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(12),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              onChangeServer();
            },
          ),
          Divider(color: Colors.white.withValues(alpha: 0.08)),

          // 2. Retire Player A
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              decoration: BoxDecoration(
                color: AppColors.liveRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
              child: const Icon(
                Icons.person_off_rounded,
                color: AppColors.liveRed,
              ),
            ),
            title: Text(
              'Retire $homeTeamName',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Concede match win to $awayTeamName',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(12),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmRetirement(context, 'A', homeTeamName);
            },
          ),
          Divider(color: Colors.white.withValues(alpha: 0.08)),

          // 3. Retire Player B
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              decoration: BoxDecoration(
                color: AppColors.liveRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
              child: const Icon(
                Icons.person_off_rounded,
                color: AppColors.liveRed,
              ),
            ),
            title: Text(
              'Retire $awayTeamName',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Concede match win to $homeTeamName',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(12),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmRetirement(context, 'B', awayTeamName);
            },
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
        ],
      ),
    );
  }

  void _confirmRetirement(
      BuildContext context, String side, String sideName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Confirm Retirement',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Are you sure $sideName is retiring? The opponent will be awarded the match win. (This action can be undone).',
          style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.liveRed,
            ),
            onPressed: () {
              Navigator.pop(context);
              onRetirePlayer(side);
            },
            child: Text('Retire', style: AppTypography.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
