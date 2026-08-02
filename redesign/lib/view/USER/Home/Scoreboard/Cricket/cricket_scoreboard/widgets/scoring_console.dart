import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onWicket;
  final VoidCallback onExtras;
  final bool canUndo;

  const ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onWicket,
    required this.onExtras,
    this.canUndo = true,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(12),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            _actionButton(
              'UNDO',
              Icons.undo_rounded,
              canUndo
                  ? AppColors.textPrimary.withValues(alpha: 0.24)
                  : AppColors.textPrimary.withValues(alpha: 0.08),
              canUndo ? onUndo : () {},
              textColor: canUndo
                  ? AppColors.textPrimary
                  : AppColors.muted.withValues(alpha: 0.4),
            ),
            SizedBox(width: ResponsiveHelper.w(8)),
            _actionButton(
              'WICKET',
              Icons.close_rounded,
              AppColors.error.withValues(alpha: 0.2),
              onWicket,
              textColor: AppColors.error,
            ),
            SizedBox(width: ResponsiveHelper.w(8)),
            _actionButton(
              'EXTRAS',
              Icons.add_circle_outline_rounded,
              AppColors.coinsGold.withValues(alpha: 0.2),
              onExtras,
              textColor: AppColors.coinsGold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color bg,
    VoidCallback onTap, {
    Color textColor = AppColors.textPrimary,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          child: Column(
            children: [
              Icon(icon, color: textColor, size: 20),
              SizedBox(height: ResponsiveHelper.h(8)),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoringNumberRow extends StatelessWidget {
  final Function(int) onNormalRun;

  const ScoringNumberRow({super.key, required this.onNormalRun});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.w(16),
        ResponsiveHelper.h(12),
        ResponsiveHelper.w(16),
        ResponsiveHelper.h(12) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(32)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [0, 1, 2, 3, 4, 6].map((runs) {
          return _runButton(runs, () => onNormalRun(runs));
        }).toList(),
      ),
    );
  }

  Widget _runButton(int runs, VoidCallback onTap) {
    final isBound = runs == 4 || runs == 6;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(52),
        height: ResponsiveHelper.h(52),
        decoration: BoxDecoration(
          color: isBound
              ? AppColors.accent
              : AppColors.textPrimary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          boxShadow: isBound
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$runs',
          style: TextStyle(
            color: isBound ? AppColors.background : AppColors.textPrimary,
            fontSize: ResponsiveHelper.sp(20),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
