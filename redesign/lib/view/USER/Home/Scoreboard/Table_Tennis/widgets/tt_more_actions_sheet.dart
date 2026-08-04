import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TtMoreActionsSheet extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final int sideATimeoutsLeft;
  final int sideBTimeoutsLeft;
  final bool isExpediteActive;
  final Function(String side) onCallTimeout;
  final VoidCallback onToggleExpedite;
  final VoidCallback onChangeServer;
  final Function(String retiringSide) onRetirePlayer;

  const TtMoreActionsSheet({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.sideATimeoutsLeft,
    required this.sideBTimeoutsLeft,
    required this.isExpediteActive,
    required this.onCallTimeout,
    required this.onToggleExpedite,
    required this.onChangeServer,
    required this.onRetirePlayer,
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
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: ResponsiveHelper.w(40),
                height: ResponsiveHelper.h(4),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),
            Text(
              'MATCH ACTIONS',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.primaryGreen,
                fontSize: context.responsiveFont(12),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16)),

            // Timeouts Row
            Text(
              'TIMEOUTS (1 Min)',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.mutedText,
                fontSize: context.responsiveFont(10),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: sideATimeoutsLeft > 0
                        ? () {
                            Navigator.pop(context);
                            onCallTimeout('A');
                          }
                        : null,
                    icon: const Icon(Icons.timer_rounded, size: 18),
                    label: Text(
                      'Timeout $homeTeamName ($sideATimeoutsLeft left)',
                      style: AppTypography.bodySm.copyWith(
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardSurface,
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: sideBTimeoutsLeft > 0
                        ? () {
                            Navigator.pop(context);
                            onCallTimeout('B');
                          }
                        : null,
                    icon: const Icon(Icons.timer_rounded, size: 18),
                    label: Text(
                      'Timeout $awayTeamName ($sideBTimeoutsLeft left)',
                      style: AppTypography.bodySm.copyWith(
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardSurface,
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16)),

            // Expedite System Toggle
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                decoration: BoxDecoration(
                  color: isExpediteActive
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                ),
                child: Icon(
                  Icons.speed_rounded,
                  color: isExpediteActive ? AppColors.warning : AppColors.mutedText,
                  size: 20,
                ),
              ),
              title: Text(
                'Expedite System',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                ),
              ),
              subtitle: Text(
                isExpediteActive ? 'Active (13-stroke limit)' : 'Inactive',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(12),
                ),
              ),
              trailing: Switch(
                value: isExpediteActive,
                activeThumbColor: AppColors.warning,
                activeTrackColor: AppColors.warning.withValues(alpha: 0.5),
                onChanged: (val) {
                  Navigator.pop(context);
                  onToggleExpedite();
                },
              ),
            ),
            const Divider(color: AppColors.divider),

            // Change Server Button
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                ),
                child: const Icon(
                  Icons.swap_calls_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              title: Text(
                'Change Server Manually',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                ),
              ),
              subtitle: Text(
                'Override current serve rotation',
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
            const Divider(color: AppColors.divider),

            // Retire Player Options
            Text(
              'RETIREMENT (CONCEDE MATCH)',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.error,
                fontSize: context.responsiveFont(10),
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetirePlayer('A');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.15),
                      foregroundColor: AppColors.error,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                        side: const BorderSide(color: AppColors.error, width: 1),
                      ),
                    ),
                    child: Text(
                      'Retire $homeTeamName',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: context.responsiveFont(12),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetirePlayer('B');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.15),
                      foregroundColor: AppColors.error,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                        side: const BorderSide(color: AppColors.error, width: 1),
                      ),
                    ),
                    child: Text(
                      'Retire $awayTeamName',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: context.responsiveFont(12),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
          ],
        ),
      ),
    );
  }
}
