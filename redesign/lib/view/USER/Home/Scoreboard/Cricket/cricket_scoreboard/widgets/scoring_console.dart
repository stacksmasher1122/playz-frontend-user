import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onWicket;
  final VoidCallback onExtras;
  final Function(int) onNormalRun;

  ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onWicket,
    required this.onExtras,
    required this.onNormalRun,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(32))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _actionButton(
                  'UNDO',
                  Icons.undo_rounded,
                  Colors.white24,
                  onUndo,
                ),
                SizedBox(width: 12),
                _actionButton(
                  'WICKET',
                  Icons.close_rounded,
                  AppColors.error.withValues(alpha: 0.2),
                  onWicket,
                  textColor: AppColors.error,
                ),
                SizedBox(width: 12),
                _actionButton(
                  'EXTRAS',
                  Icons.add_circle_outline_rounded,
                  Colors.amber.withValues(alpha: 0.2),
                  onExtras,
                  textColor: Colors.amber,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [0, 1, 2, 3, 4, 6].map((runs) {
                return _runButton(runs, () => onNormalRun(runs));
              }).toList(),
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
    Color textColor = Colors.white,
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
              SizedBox(height: 4),
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

  Widget _runButton(int runs, VoidCallback onTap) {
    final isBound = runs == 4 || runs == 6;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(52),
        height: ResponsiveHelper.h(52),
        decoration: BoxDecoration(
          color: isBound ? AppColors.accent : Colors.white10,
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
            color: isBound ? Colors.black : Colors.white,
            fontSize: ResponsiveHelper.sp(20),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
